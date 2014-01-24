//
//  TKGame.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKGame.h"

@implementation TKGame

static TKGame *sharedInstance = nil;

+(TKGame *)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[TKGame alloc] init];
    }
    
    return sharedInstance;
}

@end
