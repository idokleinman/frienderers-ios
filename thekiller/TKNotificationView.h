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
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;
@property (strong, nonatomic) IBOutlet TKView *popupView;
@property (nonatomic) BOOL needsToFadeOut;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *fbProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *singleLabel;
@end
