//
//  TKShootViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKShootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TKBluetoothManager.h"
#import "TKDevice.h"
#import "TKSoundManager.h"
#import "TKAppViewController.h"


@interface TKShootViewController ()

@end

@implementation TKShootViewController
{
    BOOL _isTargetInRange;
    BOOL _isGunLoaded;
}

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
    
    self.gunLoadedLabel.attributedText = getAsSmallAttributedString(self.gunLoadedLabel.text, NSTextAlignmentCenter);
    self.instructionLabel.attributedText = getAsSmallAttributedString(self.instructionLabel.text, NSTextAlignmentCenter);
    self.shootLabel.attributedText = getAsSmallAttributedString(self.shootLabel.text, NSTextAlignmentCenter);
    
    // Create and initialize a tap gesture
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToCocking:)];
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:panRecognizer];
    
    _isGunLoaded = NO;
    _isTargetInRange = NO;
        
    [[TKBluetoothManager sharedManager] startWithName:@"temp"];//self.server.profileID]; //$$$
    [[TKBluetoothManager sharedManager] addObserver:self forKeyPath:@"nearbyDevicesDictionary" options:NSKeyValueObservingOptionInitial context:0];

}

- (void)dealloc
{
    [[TKBluetoothManager sharedManager] removeObserver:self forKeyPath:@"nearbyDevicesDictionary" context:0];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    TKDevice *device = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary objectForKey:self.targetProfileID];
    if (device)
    {
        if (device.range == VERY_NEAR)
        {
            _isTargetInRange = YES;
            // add glow to gun icon $$$
        }
        else
            _isTargetInRange = NO;
    }
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    // Request to stop receiving accelerometer events and turn off accelerometer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


- (void) respondToCocking:(UITapGestureRecognizer *)cocking
{
    
    if (cocking.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"swipe cocking");
        _isGunLoaded = YES;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [[TKSoundManager sharedManager] playSound:@"loadgun"];
    }
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if (_isGunLoaded)
        {
            _isGunLoaded = NO;
            // play shoot sound
            NSLog(@"motion shake -- shoot");
            
            [[TKSoundManager sharedManager] playSound:@"shoot"];
            NSMutableArray *nearByPlayersArr = [[NSMutableArray alloc] init];
            NSArray *devicesArr = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary allValues];
            
            for (TKDevice *d in devicesArr)
            {
                if (d.range <= MEDIUM)
                    [nearByPlayersArr addObject:d.name];
            }
            
            [[TKServer sharedInstance] shootTarget:self.targetProfileID success:_isTargetInRange nearby:nearByPlayersArr completion:^(NSString *nextTargetID, NSError *error) {
                if ((error) || (!nextTargetID)) {
                    [[UIAlertView alertWithError:error] show];
                    return;
                }
                
                if ([nextTargetID isEqualToString:self.targetProfileID]) {
                    NSLog(@"shooting failed, target did not change");
//                    [[[UIAlertView alloc] initWithTitle:@"You failed" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
//                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotificationReceived" object:nil userInfo:@{@"loc-args":@{@"type":@(remoteNotificationKillFailed)}}];
                    return;
                }
                else
                if ([nextTargetID isEqualToString:[TKServer sharedInstance].userid]) {
                    NSLog(@"shooting success, you are the last man, you win!");
//                    [[[UIAlertView alloc] initWithTitle:@"You win!" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                    [self performSegueWithIdentifier:@"win" sender:self];
                    
                    //$$$
                    return;
                }
                else
                {
                    
                    NSLog(@"shooting success, next target aquired");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotificationReceived" object:nil userInfo:@{@"loc-args":@{@"type":@(remoteNotificationKillSucceeded)}}];

                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    //$$$
                    return;
                }
                    
                
                NSLog(@"NEXT SCREEN");
            }];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
