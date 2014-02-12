//
//  TKServer.h
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKGameInfo.h"

typedef enum {
    TKUserStateUnknown = -1,
    TKUserStateNotInvited = 0,
    TKUserStateInvited,
    TKUserStateJoined,
    TKUserStateAlive,
    TKUserStateDead
} TKUserState;


extern TKUserState TKUserStateFromNSString(NSString* s);
extern NSString* NSStringFromTKUserState(TKUserState state);


@interface TKServer : NSObject

@property (readonly, nonatomic) NSString* userid;
@property (readonly, nonatomic) NSDictionary* profile;
@property (readonly, nonatomic) TKUserState state;
@property (readonly, nonatomic) TKGameInfo* game;

+ (TKServer*)sharedInstance;

- (BOOL)openSession;
- (void)hello:(void(^)(TKGameInfo* gameInfo, NSError* error))completion;
- (void)nextTarget:(void(^)(NSString* targetUserID, NSString *targetName, NSError* error))completion;
- (void)registerPushToken:(NSString*)deviceToken;
- (void)createGameWithTitle:(NSString*)title startTime:(NSDate*)startTime playerUserIDs:(NSArray*)players completion:(void(^)(TKGameInfo* game, NSError* error))completion;
- (void)shootTarget:(NSString*)targetID success:(BOOL)success nearby:(NSArray*)nearby completion:(void(^)(NSString* nextTargetID, NSString *targetName, NSError* error))completion;
- (void)joinGame:(void(^)(BOOL success, NSError* error))completion;
- (void)startGame:(NSString*)gameid completion:(void(^)(NSDictionary* game, NSError* error))completion;
- (void)allGames:(void(^)(NSArray* games, NSError* error))completion;
- (void)detailsForGameID:(NSString*)gameID completion:(void(^)(TKGameInfo* gameInfo, NSError* error))completion;

@end
