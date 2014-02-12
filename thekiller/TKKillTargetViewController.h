//
//  TKkillTargetViewController.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStyle.h"
#import "TKProfilePictureView.h"

@interface TKKillTargetViewController : UIViewController
@property (weak, nonatomic) IBOutlet TKSmallLabel *killLabel;
@property (weak, nonatomic) IBOutlet TKProfilePictureView *nextTargetFBProfileImage;
@property (strong, nonatomic) IBOutlet TKSmallLabel *buttonTitle;
@property (strong, nonatomic) IBOutlet TKBigLabel *wantedLabel;
@property (strong, nonatomic) IBOutlet TKBigLabel *deadOrDeadLabel;

@end
