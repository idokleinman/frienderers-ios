//
//  TKGame.h
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKGame : NSObject

@property (strong, nonatomic) NSString *gameID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *creatorFBID;
@property (strong, nonatomic) NSDate *startTime;


+(TKGame *)sharedInstance;
@end
