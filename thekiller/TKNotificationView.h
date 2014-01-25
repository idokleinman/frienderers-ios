//
//  TKNotificationView.h
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStyle.h"

@interface TKNotificationView : TKView
@property (strong, nonatomic) IBOutlet TKSmallLabel *headerLabel;
@property (strong, nonatomic) IBOutlet TKBigLabel *topTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet TKBigLabel *bottomTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet TKSmallLabel *buttonLabel;
@property (strong, nonatomic) IBOutlet TKView *popupView;
@property (nonatomic) BOOL needsToFadeOut;

@end
