//
//  TKServerController.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>

// dummy server class
@interface TKServerController : UIViewController


+(id)sharedServer;
- (void)loadGameInformation:(void(^)(NSDictionary* gameInfo, NSError* error))completion;
- (void)loadNextTarget:(void(^)(NSString* nextTargetProfileID, NSError* error))completion;

-(void)postShoot:(BOOL)killSuccess nearByPlayers:(NSArray *)nearByPlayers completionBlock:(void(^)(BOOL ack, NSError* error))completion;

@property (nonatomic, strong) NSString* myProfileID;

@end
