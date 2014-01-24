//
//  TKDevice.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKDevice : NSObject

@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSArray* rssiSamples;
@property (readonly, nonatomic) NSInteger prevRSSI;
@property (readonly, nonatomic) NSInteger rssi;

- (id)initWithName:(NSString*)name;
- (void)addSample:(NSNumber*)sample;

@end