//
//  TKJoinMasacareViewController.h
//  GGJ
//
//  Created by Idan Buberman on 1/25/14.
//  Copyright (c) 2014 Idan Buberman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKStyle.h"
#import "TKServer.h"
#import "TKGameInfo.h"

@interface TKJoinMasacareViewController : UIViewController 

@property (weak, nonatomic) IBOutlet TKSmallLabel *joinGameLabel;
@property (weak, nonatomic) IBOutlet TKSmallLabel *acceptOrDie;
@property (weak, nonatomic) IBOutlet TKButton *joinGameButton;
@property (strong, nonatomic) TKGameInfo *gameInvintationInfo;

@end
