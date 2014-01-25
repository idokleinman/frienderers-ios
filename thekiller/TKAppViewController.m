//
//  TKAppViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKAppViewController.h"
#import "TKNotificationView.h"

@interface TKAppViewController ()


@end

@implementation TKAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"remoteNotificationReceived" object:nil];
    
    
    [self performSelector:@selector(showAlert) withObject:Nil afterDelay:3.0];
}

-(void)showAlert
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
//    TKBigLabel *label = [[TKBigLabel alloc] initWithFrame:view.frame];
//    [label setText:@"HI THIS IS A TEST FOR VIEW"];
//    [label setFont:[UIFont fontWithName:@"Rosewood" size:28]];
//    
//    [view setBackgroundColor:[UIColor redColor]];
//    
//    [view addSubview:label];
//    
//    [self.view addSubview:view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotificationReceived" object:nil userInfo:@{@"loc-args":@{@"type":@(remoteNotificationKillFailed), @"name":@"Amit"}}];
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
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.jpg"]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            break;
            
        case remoteNotificationKillFailed:
            // popup
//            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
//            [view.popupView.layer setBorderWidth:2.0];
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
//            [view.popupView.layer setBorderColor:[UIColor redColor].CGColor];
//            [view.popupView.layer setBorderWidth:2.0];
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
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.jpg"]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            view.continueButton.hidden = YES;
            view.buttonLabel.hidden = YES;
            view.needsToFadeOut = YES;
            view.singleLabel.hidden = YES;
            break;
            
        case remoteNotificationSomeoneWin:
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just killed the last victim", data[@"loc-args"][@"name"]],NSTextAlignmentCenter)];
            view.headerLabel.hidden = YES;
            [view.topTitleLabel setText:@"WINNER"];
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.jpg"]];
            [view.bottomTitleLabel setText:@"MEGA KILLER"];
            
            [view.buttonLabel setAttributedText:getAsSmallAttributedString(@"Let's start another round", NSTextAlignmentCenter)];
            view.needsToFadeOut = NO;
            view.singleLabel.hidden = YES;
            
            break;
            
        case remoteNotificationYouDead:
            [view.headerLabel setAttributedText:getAsSmallAttributedString([NSString stringWithFormat:@"%@ just shot you", data[@"loc-args"][@"name"]], NSTextAlignmentCenter)];
            [view.topTitleLabel setText:@"YOU'RE DEAD"];
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.jpg"]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
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
