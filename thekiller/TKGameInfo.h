//
//  TKGameInfo.h
//  Frienderers
//
//  Created by Elad Ben-Israel on 1/25/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKGameInfo : NSObject

@property (readonly, nonatomic) NSString* title;
@property (readonly, nonatomic) NSDate* startTime;
@property (readonly, nonatomic) NSString* creatorID;
@property (readonly, nonatomic) NSArray* players;
@property (readonly, nonatomic) NSArray* invited;
@property (readonly, nonatomic) NSArray* joined;
@property (readonly, nonatomic) NSArray* rejected;
@property (readonly, nonatomic) NSString* gameID;
@property (readonly, nonatomic) NSDictionary* killList;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
