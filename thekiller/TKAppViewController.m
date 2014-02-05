//
//  TKAppViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKAppViewController.h"
#import "TKNotificationView.h"
#import "TKServer.h"
#import "TKAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

TKAppViewController* AppController() {
    return ((TKAppDelegate*)[UIApplication sharedApplication].delegate).appViewController;
}

@interface TKInternalViewController : UIViewController

@end

@implementation TKInternalViewController
@end

@interface TKAppViewController ()

@property (strong, nonatomic) TKInternalViewController* internalViewController;

@end

@implementation TKAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"remoteNotificationReceived" object:nil];
    
    UINavigationController* n = self.childViewControllers[0];
    self.internalViewController = (TKInternalViewController*)n.topViewController;
    
//    [self performSelector:@selector(showAlert) withObject:nil afterDelay:3.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadState];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)showAlert
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotificationReceived" object:nil userInfo:@{@"loc-args":@{@"type":@(remoteNotificationYouDead), @"name":@"Amit"}}];

}

- (void)reloadState {
    NSLog(@"reload state");

    [[TKServer sharedInstance] hello:^(TKGameInfo *gameInfo, NSError *error) {
        [self.internalViewController dismissViewControllerAnimated:NO completion:nil];
        
        if (gameInfo) {
            [self.internalViewController performSegueWithIdentifier:@"game" sender:self];
        }
        else {
            [self.internalViewController performSegueWithIdentifier:@"create" sender:self];
        }
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(TKNotificationView *)createNotificationViewWithData:(NSDictionary *)data
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TKNotificationView" owner:self options:nil];
    TKNotificationView *view = arr[0];
    
    RemoteNotifications type = (RemoteNotifications)[data[@"loc-args"][@"type"] intValue];
    
    switch (type) {
        case remoteNotificationKillSucceeded:
            //popup
            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
            [view.popupView.layer setBorderWidth:2.0];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"KILLED"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            [view.fbProfilePicture setProfileID:data[@"loc-args"][@"subjectid"]];
            [view.fbProfilePicture setPictureCropping:FBProfilePictureCroppingSquare];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            break;
            
        case remoteNotificationKillFailed:
            // popup
            [view.singleLabel setAttributedText:getAsPopupAttributedString(@"Witness \n Warning!", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.profilePicture.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            break;
        
        case remoteNotificationRunAway:
            // popup
            [view.singleLabel setAttributedText:getAsPopupAttributedString(@"Shooting \n Nearby!", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.profilePicture.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            break;
            
        case remoteNotificationSomeoneDied:
            // popup
            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
            [view.popupView.layer setBorderWidth:2.0];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"KILLED"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            [view.fbProfilePicture setProfileID:data[@"loc-args"][@"subjectid"]];
            [view.fbProfilePicture setPictureCropping:FBProfilePictureCroppingSquare];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            break;
            
        case remoteNotificationSomeoneWin:
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just killed the last victim", data[@"loc-args"][@"name"]],NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"WINNER"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            [view.fbProfilePicture setProfileID:data[@"loc-args"][@"subjectid"]];
            [view.fbProfilePicture setPictureCropping:FBProfilePictureCroppingSquare];
            [view.bottomTitleLabel setText:@"MEGA KILLER"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Let's start another round", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            view.singleLabel.hidden = YES;
            
            break;
            
        case remoteNotificationYouDead:
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just shot you", data[@"loc-args"][@"name"]], NSTextAlignmentCenter)];
            [view.topTitleLabel setText:@"YOU'RE DEAD"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:40.0]];
            
            [view.fbProfilePicture setProfileID:data[@"loc-args"][@"subjectid"]];
            [view.fbProfilePicture setPictureCropping:FBProfilePictureCroppingSquare];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"You won't be forgotten & will be updated with the events to come", NSTextAlignmentCenter)];
            view.singleLabel.hidden = YES;
            view.needsToFadeOut = NO;
            break;
            
        case remoteNotificationGameBegins:
            [view.singleLabel setAttributedText:getAsSmallAttributedString(@"The game is starting now! \n Ther's no way out \n All you have left is to kill or die", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.profilePicture.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            
            view.needsToFadeOut = YES;
            break;
            
        case remoteNotificationsInviteReceived:
        {
            NSString *str = [NSString stringWithFormat:@"%@ has invited you to join a Frienderers game starts on %@", data[@"loc-args"][@"name"], data[@"loc-args"][@"start_time"]];
            
            [view.singleLabel setAttributedText:getAsSmallAttributedString(str, NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.profilePicture.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = NO;
            view.buttonLabel.hidden = NO;
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Accept or die!", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            break;
        }
        default:
            break;
    }
    
    return view;
}

-(void)handleNotification:(NSNotification *)notification
{
    TKNotificationView *view = [self createNotificationViewWithData:notification.userInfo];
//    view.center = self.view.center;
    view.alpha = 0;
    [self.view addSubview:view];
//    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (view.needsToFadeOut) {
            [self performSelector:@selector(closeNotificationView:) withObject:view afterDelay:7.0];
        }
    }];
}

-(void)closeNotificationView:(UIView *)view
{
    if (view.superview) {
        [view removeFromSuperview];
    }
}

@end
