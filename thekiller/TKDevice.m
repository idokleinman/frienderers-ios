//
//  TKDevice.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKDevice.h"


@interface TKDevice ()
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* rssiSamples;
@end

@implementation TKDevice
- (id)initWithName:(NSString*)name {
    if (self = [super init]) {
        self.name = name;
        self.rssiSamples = [NSMutableArray new];
    }
    return self;
}
-(void)addSample:(NSNumber *)sample{
    NSMutableArray* samples = (NSMutableArray*)self.rssiSamples;
    [samples addObject:sample];
    if (samples.count > 50) {
        [samples removeObjectAtIndex:0];
    }
    
    NSInteger sum = 0;
    for (NSNumber* sample in samples) {
        sum += [sample integerValue];
    }
    
    _prevRSSI = _rssi;
    _rssi = (NSInteger)((CGFloat)sum / samples.count);
}

-(rangeType)range
{
    if (self.rssi < -90)
        return VERY_FAR;
    
    if ((self.rssi < -70) && (self.rssi > -90))
        return FAR;
        
    if ((self.rssi < -50) && (self.rssi > -70))
        return MEDIUM;
    
    if ((self.rssi < -30) && (self.rssi > -50))
        return NEAR;
    
    if (self.rssi > -30)
        return VERY_NEAR;
 
    
    return VERY_FAR;
}

- (NSString *)description {
    return self.name;
}

@end