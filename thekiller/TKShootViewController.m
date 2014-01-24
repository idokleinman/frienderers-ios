//
//  TKShootViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKShootViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TKShootViewController ()

@end

@implementation TKShootViewController

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
    // Create and initialize a tap gesture
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToCocking:)];
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:panRecognizer];
    
    self.isGunLoaded = NO;
}


- (void) viewWillDisappear:(BOOL)animated
{
    // Request to stop receiving accelerometer events and turn off accelerometer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


- (void) respondToCocking:(UITapGestureRecognizer *)shot
{
    NSLog(@"swipe cocking");
    self.isGunLoaded = YES;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}



- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (_isGunLoaded)
    {
        if (motion == UIEventSubtypeMotionShake)
        {
            self.isGunLoaded = NO;
            NSLog(@"motion shake -- shoot");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
