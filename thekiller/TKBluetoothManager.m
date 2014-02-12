//
//  TKPeripheral.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

@import CoreBluetooth;

#import "TKBluetoothManager.h"
#import "TKDevice.h"
#import "TKServer.h"
#import "TKAppViewController.h"

NSString* const SERVICE_UUID = @"0194827D-A9F6-4500-8AC3-BB6189EEE15E";
NSString* const CHARACTERISTIC_UUID = @"BD5DF558-9DF1-4216-8521-411D6F917A8C";


@interface TKBluetoothManager () <CBPeripheralManagerDelegate, CBCentralManagerDelegate>

// peripheral
@property (strong, nonatomic) CBPeripheralManager* peripheral;
@property (strong, nonatomic) NSString* peripheralStatus;

// central
@property (strong, nonatomic) CBCentralManager* central;
@property (strong, nonatomic) NSString* centralStatus;

@property (strong, nonatomic) NSMutableDictionary* nearbyDevicesDictionary;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *lastUpdate;

@property (strong, nonatomic) TKNotificationView *notificationView;
@end

@implementation TKBluetoothManager

+ (TKBluetoothManager *)sharedManager
{
    static TKBluetoothManager* s = NULL;
    if (!s) {
        s = [[TKBluetoothManager alloc] init];
    }
    
    return s;
}

- (void)startWithName:(NSString *)name
{
    NSParameterAssert(name);
    _name = name;
    // set up peripheral
    NSData* data = [@"Hello, world" dataUsingEncoding:NSUTF8StringEncoding];
    
    CBMutableCharacteristic* characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];
    CBMutableService* service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_UUID] primary:YES];
    service.characteristics = @[ characteristic ];
    self.peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) options:nil];
    [self.peripheral addService:service];
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) options:nil];
    
    self.nearbyDevicesDictionary = [NSMutableDictionary new];
    [self peripheralManagerDidUpdateState:self.peripheral];
    [self centralManagerDidUpdateState:self.central];
}

#pragma mark - Peripheral

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    self.peripheralStatus = DescriptionForState(peripheral.state);
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSDictionary* d = @{ CBAdvertisementDataLocalNameKey: self.name,
                             CBAdvertisementDataServiceUUIDsKey: @[ [CBUUID UUIDWithString:SERVICE_UUID] ] };
        
        [self.peripheral startAdvertising:d];
    }
    
    NSLog(@"Peripheral Status: %@", self.peripheralStatus);
    
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error adding service: %@", error);
    }
}

#pragma mark - Central

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.centralStatus = DescriptionForState(central.state);
    NSLog(@"Central Status: %@", self.centralStatus);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.central scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:SERVICE_UUID] ] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothIsOffNotification" object:self userInfo:@{@"isBluetoothWorking":@(YES)}];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothIsOffNotification" object:self userInfo:@{@"isBluetoothWorking":@(NO)}];
    }
}

- (TKDevice*)deviceWithName:(NSString*)name {
    TKDevice* device = self.nearbyDevicesDictionary[name];
    if (!device) {
        device = self.nearbyDevicesDictionary[name] = [[TKDevice alloc] initWithName:name];
    }
    return  device;
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (!peripheral.name) {
        return;
    }
    NSLog(@"discovered %@ with RSSI %d",peripheral.name,[RSSI intValue]);
    TKDevice* device = [self deviceWithName:peripheral.name];
    [device addSample:RSSI];
    
    for (TKDevice* device in [self.nearbyDevicesDictionary allValues])
    {
        NSTimeInterval iv = [[NSDate date] timeIntervalSinceDate:device.lastUpdate];
        if (iv > 3.0f) // kill devices older than 3 seconds from last update
        {
            [self.nearbyDevicesDictionary removeObjectForKey:device.name];
            NSLog(@"device %@ is out of range",device.name);
        }
    }
    
    if (device.rssi != device.prevRSSI) {
        [self willChangeValueForKey:@"nearbyDevicesDictionary"];
        [self didChangeValueForKey:@"nearbyDevicesDictionary"];
        
        NSLog(@"Updated %@ with RSSI %d",device.name,device.rssi);
    }
}

#pragma mark - Utilities

NSString* DescriptionForState(NSInteger state)
{
    NSString* description;
    
    switch (state) {
        case CBPeripheralManagerStateUnsupported:
            description = NSLocalizedString(@"Bluetooth LE is not supported", nil);
            break;
            
        case CBPeripheralManagerStateUnauthorized:
            description = NSLocalizedString(@"Unauthorized", nil);
            break;
            
        case CBPeripheralManagerStatePoweredOff:
            description = NSLocalizedString(@"Bluetooth is off", nil);
            break;
            
        case CBPeripheralManagerStatePoweredOn:
            description = NSLocalizedString(@"OK", nil);
            break;
            
        case CBPeripheralManagerStateUnknown:
        case CBPeripheralManagerStateResetting:
        default:
            description = NSLocalizedString(@"Connecting...", nil);
            break;
    }
    
    return description;
}

- (void) observeStateOfBluetooth
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBluetoothNotify:) name:@"bluetoothIsOffNotification" object:nil];
}

- (void) handleBluetoothNotify:(NSNotification *)notification
{
    if (notification.userInfo[@"isBluetoothWorking"]){
        self.notificationView = [AppController() showNotification:@{@"type":@(remoteNotificationsBTClosed)}];
    } else {
        if (self.notificationView) {
            [AppController() closeNotificationView:self.notificationView];
        }
    }
}

@end
