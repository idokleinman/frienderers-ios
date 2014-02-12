//
//  TKAppViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKAppViewController.h"
#import "TKServer.h"
#import "TKAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSObject+Binding.h"

TKAppViewController* AppController() {
    return ((TKAppDelegate*)[UIApplication sharedApplication].delegate).appViewController;
}

@interface TKInternalViewController : UIViewController
@end

@implementation TKInternalViewController
@end

@interface TKAppViewController ()

@property (strong, nonatomic) TKInternalViewController* internalViewController;
@property (strong, nonatomic) IBOutlet UIButton* testerButton;

@end

@implementation TKAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef DEBUG
    self.testerButton.hidden = NO;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"remoteNotificationReceived" object:nil];
    
    UINavigationController* n = self.childViewControllers[0];
    self.internalViewController = (TKInternalViewController*)n.topViewController;
    
    self.profilePictures = [NSMutableDictionary dictionary];
    
    [[TKServer sharedInstance] addObserver:self forKeyPath:@"state" callback:^(id value) {
        [self refreshUI];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadState];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)refreshUI {
    NSString* currentState = NSStringFromTKUserState([TKServer sharedInstance].state);
    NSLog(@"current state: %@", currentState);
    if (!currentState) {
        return;
    }
    [self.internalViewController.navigationController popToRootViewControllerAnimated:NO];
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:currentState];
    [self.internalViewController.navigationController pushViewController:vc animated:NO];
}

- (void)reloadState {
    NSLog(@"reload state");
    [[TKServer sharedInstance] hello:^(TKGameInfo *gameInfo, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
            return;
        }
        
        NSLog(@"Hello SUCCESS");
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (TKNotificationView *)createNotificationViewWithData:(NSDictionary *)data {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TKNotificationView" owner:self options:nil];
    TKNotificationView *view = arr[0];
    
    RemoteNotifications type = (RemoteNotifications)[data[@"type"] intValue];
    
    NSString *title;

    switch (type) {
        case remoteNotificationKillSucceeded:
            title = @"remoteNotificationKillSucceeded";
            /*
            //popup
            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
            [view.popupView.layer setBorderWidth:2.0];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"KILLED"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            view.fbProfilePicture.fbid = data[@"subjectid"];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            */
            break;
            
        case remoteNotificationKillFailed:
            title = @"remoteNotificationKillFailed";
            /*
            // popup
            [view.singleLabel setAttributedText:getAsPopupAttributedString(@"Witness \n Warning!", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            */
            break;
        
        case remoteNotificationRunAway:
            title = @"remoteNotificationRunAway";
            /*
            // popup
            [view.singleLabel setAttributedText:getAsPopupAttributedString(@"Shooting \n Nearby!", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            */
            break;
            
        case remoteNotificationSomeoneDied:
            title = @"remoteNotificationSomeoneDied";
            /*
            // popup
            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
            [view.popupView.layer setBorderWidth:2.0];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"KILLED"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            view.fbProfilePicture.fbid = data[@"subjectid"];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            */
            break;
            
        case remoteNotificationSomeoneWin:
            title = @"remoteNotificationSomeoneWin";
            /*
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just killed the last victim", data[@"name"]],NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"WINNER"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
            view.fbProfilePicture.fbid = data[@"subjectid"];
            [view.bottomTitleLabel setText:@"MEGA KILLER"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Let's start another round", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            view.singleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            */
            break;
            
        case remoteNotificationYouDead:
            title = @"remoteNotificationYouDead";
            /*
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just shot you", data[@"name"]], NSTextAlignmentCenter)];
            [view.topTitleLabel setText:@"YOU'RE DEAD"];
            [view.topTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:40.0]];
            view.fbProfilePicture.fbid = data[@"subjectid"];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            [view.bottomTitleLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
            view.continueButton.hidden = YES;
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"You won't be forgotten & will be updated with the events to come", NSTextAlignmentCenter)];
            view.singleLabel.hidden = YES;
            view.needsToFadeOut = NO;
            view.notificationImage.hidden = YES;
            */
            break;
            
        case remoteNotificationGameBegins:
            title = @"remoteNotificationGameBegins";
            /*
            [view.singleLabel setAttributedText:getAsSmallAttributedString(@"The game is starting now! \n There's no way out \n All you have left is to kill or die", NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            */
            break;
            
        case remoteNotificationsInviteReceived:
        {
            title = @"remoteNotificationsInviteReceived";
            /*
            NSString *str = [NSString stringWithFormat:@"%@ has invited you to join a Frienderers game starts on %@", data[@"name"], data[@"start_time"]];
            
            [view.singleLabel setAttributedText:getAsSmallAttributedString(str, NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.notificationImage.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.fbProfilePicture.hidden = YES;
            view.continueButton.hidden = NO;
            view.buttonLabel.hidden = NO;
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Accept or die!", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            */
            break;
        }
            
        case remoteNotificationsBTClosed:
        {
            title = @"remoteNotificationsBTClosed";
            /*
            UIImage *bluetoothImage = [UIImage imageNamed:@"BlueTooth"];
            
            [view.notificationImage setImage:bluetoothImage];
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Frienderers is using only Bluetooth Low Energy, \n so it won't kill your battery", NSTextAlignmentCenter)];
            [view.singleLabel setAttributedText:getAsSmallAttributedString(@"Bluetooth is your secret weapon & \n it must be enabled at all times", NSTextAlignmentCenter)];
            
            view.notificationImage.hidden = NO;
            view.buttonLabel.hidden = NO;
            view.singleLabel.hidden = NO;
            view.fbProfilePicture.hidden = YES;
            view.headerLabel.hidden = YES;
            view.topTitleLabel.hidden = YES;
            view.bottomTitleLabel.hidden = YES;
            view.continueButton.hidden = YES;
            view.needsToFadeOut = NO;
            */
            break;
        }
            
        default:
            title = @"Unknown notification";
            break;
    }
    
    [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return view;
}

-(TKNotificationView *)showNotification:(NSDictionary *)params
{
    TKNotificationView *view = [self createNotificationViewWithData:params];
    
    view.alpha = 0;
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (view.needsToFadeOut) {
            [self performSelector:@selector(closeNotificationView:) withObject:view afterDelay:7.0];
        }
    }];
    
    return view;
}

-(void)handleNotification:(NSNotification *)notification
{
    TKNotificationView *view = [self createNotificationViewWithData:notification.userInfo[@"loc-args"]];
    view = nil;
//    [self showNotification:notification.userInfo[@"loc-args"]];
}

-(void)closeNotificationView:(TKNotificationView *)view
{
    if (view.superview) {
        [view removeFromSuperview];
    }
}

#pragma mark - Tester

- (IBAction)showTester:(id)sender {
    [self performSegueWithIdentifier:@"tester" sender:self];
}

@end
