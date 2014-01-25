//
//  TKDevice.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, rangeType) {
    VERY_NEAR = 0,
    NEAR,
    MEDIUM,
    FAR,
    VERY_FAR
};

@interface TKDevice : NSObject

@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSArray* rssiSamples;
@property (readonly, nonatomic) NSInteger prevRSSI;
@property (readonly, nonatomic) NSInteger rssi;
@property (readonly, nonatomic) rangeType range;


- (id)initWithName:(NSString*)name;
- (void)addSample:(NSNumber*)sample;

@end