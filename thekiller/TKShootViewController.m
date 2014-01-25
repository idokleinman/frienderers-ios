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
#import "TKServerController.h"

@interface TKShootViewController ()
@property (strong, nonatomic) TKServerController* server; //TKServer $$$
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
    // Create and initialize a tap gesture
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToCocking:)];
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:panRecognizer];
    
    _isGunLoaded = NO;
    _isTargetInRange = NO;
    
    // bluetooth
    self.server = [UIApplication sharedApplication].tkapp.server;
    
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
            
            NSMutableArray *nearByPlayersArr = [[NSMutableArray alloc] init];
            NSArray *devicesArr = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary allValues];
            
            for (TKDevice *d in devicesArr)
            {
                if (d.range <= MEDIUM)
                    [nearByPlayersArr addObject:d.name];
            }
            
            [self.server postShoot:_isTargetInRange nearByPlayers:nearByPlayersArr completionBlock:^(BOOL ack, NSError *error) {
                if (!error)
                {
                    // handle ack $$$
                    // play hit/miss sound
                }
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
