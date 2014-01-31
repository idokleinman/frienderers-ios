//
//  TKShootViewController.h
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKStyle.h"
#import "TKBluetoothManager.h"
#import "TKServer.h"

@interface TKShootViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet TKButton *shootButton;


@property (strong, nonatomic) NSString* targetProfileID;
@property (weak, nonatomic) IBOutlet TKButton *gunButton;

@property (weak, nonatomic) IBOutlet UILabel *gunLoadedLabel;
@property (strong, nonatomic) IBOutlet TKSmallLabel *shootLabel;
@property (strong, nonatomic) IBOutlet TKSmallLabel *instructionLabel;

@end
