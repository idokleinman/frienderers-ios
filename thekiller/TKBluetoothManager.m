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

@end

@implementation TKBluetoothManager


static TKBluetoothManager *sharedManager = nil;

+(TKBluetoothManager *)sharedManager
{
    if (!sharedManager) {
        sharedManager = [[TKBluetoothManager alloc] init];
    }
    
    return sharedManager;
}


- (void)startWithName:(NSString *)name
{
    NSParameterAssert(name);
    
    // set up peripheral
    NSData* data = [@"Hello, world" dataUsingEncoding:NSUTF8StringEncoding];
    
    CBMutableCharacteristic* characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];
    CBMutableService* service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_UUID] primary:YES];
    service.characteristics = @[ characteristic ];
    self.peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) options:nil];
    [self.peripheral addService:service];
    
    
    
    NSDictionary* d = @{ CBAdvertisementDataLocalNameKey: name,
                         CBAdvertisementDataServiceUUIDsKey: @[ service.UUID ] };
    
    [self.peripheral startAdvertising:d];
    [self peripheralManagerDidUpdateState:self.peripheral];
    
    // set up central
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) options:nil];
    [self centralManagerDidUpdateState:self.central];
    
    self.nearbyDevicesDictionary = [NSMutableDictionary new];
    
}

#pragma mark - Peripheral

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    self.peripheralStatus = DescriptionForState(peripheral.state);
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
    
    TKDevice* device = [self deviceWithName:peripheral.name];
    [device addSample:RSSI];
    
    if (device.rssi != device.prevRSSI) {
        [self willChangeValueForKey:@"nearbyDevicesDictionary"];
        [self didChangeValueForKey:@"nearbyDevicesDictionary"];
        
        
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

@end
