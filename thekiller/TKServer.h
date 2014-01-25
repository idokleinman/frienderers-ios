//
//  TKServer.h
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKGameInfo.h"
@interface TKServer : NSObject

@property (readonly, nonatomic) NSString* userid;
@property (readonly, nonatomic) NSDictionary* profile;

+ (TKServer*)sharedInstance;

- (BOOL)openSession;
- (void)hello:(void(^)(TKGameInfo* gameInfo, NSError* error))completion;
- (void)nextTarget:(void(^)(NSString* targetUserID, NSError* error))completion;
- (void)registerPushToken:(NSString*)deviceToken;
- (void)createGameWithTitle:(NSString*)title startTime:(NSDate*)startTime playerUserIDs:(NSArray*)players completion:(void(^)(TKGameInfo* game, NSError* error))completion;
- (void)shootTarget:(NSString*)targetID success:(BOOL)success nearby:(NSArray*)nearby completion:(void(^)(NSString* nextTargetID, NSError* error))completion;

@end
