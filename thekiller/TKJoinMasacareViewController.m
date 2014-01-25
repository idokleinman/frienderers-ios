//
//  TKJoinMasacareViewController.m
//  GGJ
//
//  Created by Idan Buberman on 1/25/14.
//  Copyright (c) 2014 Idan Buberman. All rights reserved.
//

#import "TKJoinMasacareViewController.h"
#import "TKServer.h"
#import "TKAppDelegate.h"
#import "TKGameInfo.h"

@interface TKJoinMasacareViewController ()

@end

@implementation TKJoinMasacareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Button's label
    self.acceptOrDie.text = @"Accept or die!";
    
    // The date and time the game starts
    NSDate *dateGameStarts = self.gameInvintationInfo.startTime;
    
    // Formatting the day and time to string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE";
    NSString *dayGameStarts = [dateFormatter stringFromDate:dateGameStarts];
    dateFormatter.dateFormat = @"HH:MM";
    NSString *timeGameStarts = [dateFormatter stringFromDate:dateGameStarts];
    
    // Main Label
    self.joinGameLabel.text = [NSString stringWithFormat:@"%@ has invited you to join a Frienderers game \"Game Jam Massacre\" this starts %@ at %@", self.gameInvintationInfo.creatorID, dayGameStarts, timeGameStarts];
}

@end
