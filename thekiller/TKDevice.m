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
@end