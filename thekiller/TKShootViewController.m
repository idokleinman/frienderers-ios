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
#import "TKServer.h"


@interface TKShootViewController ()

@property (assign, nonatomic) BOOL targetInRange;
@property (assign, nonatomic) BOOL gunLoaded;

@end

@implementation TKShootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.instructionLabel.attributedText = getAsSmallAttributedString(self.instructionLabel.text, NSTextAlignmentCenter);
    self.shootLabel.attributedText = getAsSmallAttributedString(self.shootLabel.text, NSTextAlignmentCenter);
    
    // Create and initialize a tap gesture
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToCocking:)];
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:panRecognizer];
    
    self.gunLoaded = NO;
    self.targetInRange = NO;

    self.gunLoadedLabel.attributedText = getAsSmallAttributedString(@"Your gun is not loaded", NSTextAlignmentCenter);
    
    [[TKBluetoothManager sharedManager] addObserver:self forKeyPath:@"nearbyDevicesDictionary" options:NSKeyValueObservingOptionInitial context:0];
    
    self.gunButton.alpha = 0.5;
}

- (void)dealloc
{
    [[TKBluetoothManager sharedManager] removeObserver:self forKeyPath:@"nearbyDevicesDictionary" context:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TKDevice *device = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary objectForKey:self.targetProfileID];
        if (device)
        {
            if (device.inRange)
            {
                self.targetInRange = YES;
                // add glow to gun icon $$$
                self.gunButton.alpha = 1.0;
                
            }
            else
            {
                self.targetInRange = NO;
                self.gunButton.alpha = 0.5;
            }
        }
    });
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    
    // Request to stop receiving accelerometer events and turn off accelerometer
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewWillDisappear:animated];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void) respondToCocking:(UITapGestureRecognizer *)cocking
{
    
    if ((cocking.state == UIGestureRecognizerStateEnded) && (!self.gunLoaded))
    {
        NSLog(@"swipe cocking");
        self.gunLoaded = YES;

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [[TKSoundManager sharedManager] playSound:@"loadgun"];
        self.gunLoadedLabel.attributedText = getAsSmallAttributedString(@"Your gun is loaded!", NSTextAlignmentCenter);
    
    }
}

- (IBAction)shoot:(id)sender {
#warning Call [self shoot]
    [self shootWithSuccess:YES];
}

- (IBAction)failedShoot:(id)sender { // for debugging
    [self shootWithSuccess:NO];
}

- (void)shoot {
    if (!self.targetInRange) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your target is not in range", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ooops...", nil) otherButtonTitles:nil] show];
        return;
    }

    NSArray *nearbyPlayersArr = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary allValues];
    BOOL success = self.targetInRange && nearbyPlayersArr.count == 1;
    [self shootWithSuccess:success];
}

- (void)shootWithSuccess:(BOOL)success {
    if (self.gunLoaded) {
        self.gunLoaded = NO;
        self.gunLoadedLabel.attributedText = getAsSmallAttributedString(@"Your gun is not loaded", NSTextAlignmentCenter);
        // play shoot sound
        NSLog(@"motion shake -- shoot");
        
        [[TKSoundManager sharedManager] playSound:@"shoot"];
        
        NSArray *nearbyPlayersArr = [[TKBluetoothManager sharedManager].nearbyDevicesDictionary allValues];
        [[TKServer sharedInstance] shootTarget:self.targetProfileID success:success nearby:nearbyPlayersArr completion:^(NSString *nextTargetID, NSString *targetName, NSError *error) {
            if (error) {
                [[UIAlertView alertWithError:error] show];
                return;
            }
            
            if ([nextTargetID isEqualToString:self.targetProfileID]) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are a lame killer! There are witnesses around and you failed!", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Damn!", nil) otherButtonTitles:nil] show];
                return;
            }
            
            [AppController() refreshUI];
        }];
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self shoot];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
