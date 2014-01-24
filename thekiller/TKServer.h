//
//  TKServer.h
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKServer : NSObject

@property (readonly, nonatomic) NSString* userid;
@property (readonly, nonatomic) NSDictionary* profile;

- (BOOL)openSession;
- (void)hello:(void(^)(NSDictionary* existingGame, NSError* error))completion;

- (void)registerPushToken:(NSString*)deviceToken;
- (void)createGameWithTitle:(NSString*)title startTime:(NSDate*)startTime playerUserIDs:(NSArray*)players completion:(void(^)(NSDictionary* game, NSError* error))completion;

@end
