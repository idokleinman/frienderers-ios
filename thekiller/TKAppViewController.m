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

typedef enum {
    remoteNotificationKillSucceeded = 1,
    remoteNotificationYouWin,
    remoteNotificationKillFailed,
    remoteNotificationYouDead,
    remoteNotificationSomeoneDied,
    remoteNotificationSomeoneWin,
    remoteNotificationRunAway
} RemoteNotifications;

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
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotificationReceived" object:nil userInfo:@{@"loc-args":@{@"type":@"1"}}];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView *)createNotificationViewWithData:(NSDictionary *)data
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TKNotificationView" owner:self options:nil];
    TKNotificationView *view = arr[0];
    
    RemoteNotifications type = (RemoteNotifications)[data[@"loc-args"][@"type"] intValue];
    
    switch (type) {
        case remoteNotificationKillSucceeded:
            [view.topTitleLabel setText:@"KILLED"];
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.jpg"]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            break;
            
        case remoteNotificationKillFailed:
            [view.headerLabel setText:@"Killed Failed!"];
            [view.topTitleLabel setText:@"RUN AWAY!"];
//            [view.profilePicture setImage:[UIImage imageNamed:@"amit.png"]];
//            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            break;
        
        case remoteNotificationRunAway:
            [view.headerLabel setText:@"There was a shooting!"];
            [view.topTitleLabel setText:@"RUN AWAY!"];
//            [view.profilePicture setImage:[UIImage imageNamed:@"amit.png"]];
//            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            break;
            
        case remoteNotificationSomeoneDied:
            [view.headerLabel setText:[NSString stringWithFormat:@"%@ was", data[@"name"]]];
            [view.topTitleLabel setText:@"KILLED"];
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.png"]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            break;
            
        case remoteNotificationSomeoneWin:
            [view.topTitleLabel setText:[NSString stringWithFormat:@"%@ WINS!", data[@"name"]]];
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.png"]];
//            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            break;
            
        case remoteNotificationYouDead:
            [view.headerLabel setText:[NSString stringWithFormat:@"%@ just shot you", data[@"name"]]];
            [view.topTitleLabel setText:@"YOU'RE DEAD!"];
            [view.profilePicture setImage:[UIImage imageNamed:@"amit.png"]];
            [view.bottomTitleLabel setText:@"REST IN PEACE"];
            break;
            
        case remoteNotificationYouWin:
            [view.topTitleLabel setText:@"YOU WIN!"];
            break;
            
        default:
            break;
    }
    
    return view;
}

-(void)handleNotification:(NSNotification *)notification
{
    UIView *view = [self createNotificationViewWithData:notification.userInfo];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
