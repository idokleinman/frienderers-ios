//
//  TKNotificationView.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKNotificationView.h"
#import "TKAppViewController.h"

@implementation TKNotificationView

- (IBAction)dismissNotificationView:(UIButton *)sender {
    if ((self.superview) && (self.needsToFadeOut)) {
        [self removeFromSuperview];
    }
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    [AppController() reloadState];
    [self dismissNotificationView:nil];
}

@end
