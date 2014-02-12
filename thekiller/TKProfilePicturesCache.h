//
//  TKProfilePicturesCache.h
//  Frienderers
//
//  Created by Elad Ben-Israel on 2/12/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKProfilePicturesCache : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (BOOL)profilePictureForFBID:(NSString*)fbid completion:(void(^)(UIImage* image))completion;

@end
