//
//  TKNameAndTimeViewController.h
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStyle.h"

@interface TKNameAndTimeViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *gameName;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet TKSmallLabel *headerLabel;
@property (strong, nonatomic) IBOutlet TKSmallLabel *bottomButtonLabel;
@property (strong, nonatomic) IBOutlet UIView* loadingView;
@end
