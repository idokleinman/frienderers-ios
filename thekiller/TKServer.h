//
//  TKServer.h
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKServer : NSObject

@property (nonatomic, strong) NSString* myProfileID;


- (BOOL)openSession;
- (void)registerPushToken:(NSString*)deviceToken;

@end
