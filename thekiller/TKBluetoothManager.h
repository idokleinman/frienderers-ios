//
//  TKPeripheral.h
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKBluetoothManager : NSObject

@property (readonly, nonatomic) NSString* peripheralStatus;
@property (readonly, nonatomic) NSString* centralStatus;
@property (readonly, nonatomic) NSMutableDictionary* nearbyDevicesDictionary;

@end

@interface TKDevice : NSObject

@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSArray* rssiSamples;
@property (readonly, nonatomic) NSInteger rssi;
@property (readonly, nonatomic) NSInteger prevRSSI;

- (id)initWithName:(NSString*)name;
- (void)addSample:(NSNumber*)sample;

@end