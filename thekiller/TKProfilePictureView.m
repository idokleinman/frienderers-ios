//
//  TKProfilePictureView.m
//  Frienderers
//
//  Created by Elad Ben-Israel on 2/12/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKProfilePictureView.h"
#import "TKProfilePicturesCache.h"

@implementation TKProfilePictureView

- (void)setFbid:(NSString *)fbid {
    _fbid = fbid;

    __weak TKProfilePictureView* myself = self;
    BOOL sync = [[TKProfilePicturesCache sharedInstance] profilePictureForFBID:fbid completion:^(UIImage *image) {
        myself.image = image;
    }];
    
    if (!sync) {
        NSLog(@"image still not cached");
    }
}

@end
