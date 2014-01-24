//
//  TKShootViewController.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStyle.h"

@interface TKShootViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet TKButton *shootButton;
@property BOOL isGunLoaded;

@end
