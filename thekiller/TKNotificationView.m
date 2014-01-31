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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)dismissNotificationView:(UIButton *)sender {
    
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (IBAction)continueButtonPressed:(UIButton *)sender {
    [AppController() reloadState];
    [self dismissNotificationView:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
