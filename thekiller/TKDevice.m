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
@property (strong, nonatomic) NSMutableArray* rssiSamples;
//@property (strong, nonatomic) NSDate* lastUpdate;
@end

@implementation TKDevice

@synthesize rssi = _rssi;

- (id)initWithName:(NSString*)name {
    if (self = [super init]) {
        self.name = name;
        self.rssiSamples = [NSMutableArray new];
    }
    return self;
}


-(NSInteger)rssi
{
    @synchronized (self.rssiSamples) {
        // average the RSSI samples from the last 1.5 seconds
        NSInteger sum = 0, count = 0;
        for (NSArray* sample in self.rssiSamples)
        {
            if ([[NSDate date] timeIntervalSinceDate:sample[1]] < 1.5f)
            {
                sum += [sample[0] integerValue];
                count++;
            }
        }
        
        _prevRSSI = _rssi;
        _rssi = (NSInteger)((CGFloat)sum / count);
        
        return _rssi;
    }
}

-(void)addSample:(NSNumber *)sample
{
    @synchronized (self.rssiSamples) {
        [self.rssiSamples addObject:@[sample,[NSDate date]]];
        if (self.rssiSamples.count > 100)
        {
            [self.rssiSamples removeObjectAtIndex:0];
        }
        _lastUpdate = [NSDate date];
    }
}


-(BOOL)inRange
{
    NSTimeInterval iv = [[NSDate date] timeIntervalSinceDate:self.lastUpdate];
    if (iv < 2.0f) // kill devices older than 2 seconds from last update
    {
        if (self.rssi > -65)
            return YES;
        else
            return NO;
        
    
    }
    else
        return NO;

    
}


/*
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
*/

- (NSString *)description {
    return self.name;
}

@end