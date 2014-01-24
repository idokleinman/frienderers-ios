//
//  TKServerController.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKServerController : UIViewController


+(id)sharedServer;
- (void)loadGameInformation:(void(^)(NSDictionary* gameInfo, NSError* error))completion;
- (void)loadNextTarget:(void(^)(NSString* nextTargetProfileID, NSError* error))completion;


@end
