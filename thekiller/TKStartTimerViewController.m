//
//  TKStartTimerViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKStartTimerViewController.h"
#import "TKServer.h"

@interface TKStartTimerViewController ()

@end

@implementation TKStartTimerViewController
{
    NSDate* _gameStartTime;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

-(void)startGame
{
    [self performSegueWithIdentifier:@"nextTarget" sender:self];
    
    // perform segue
    
}

-(void)runGameStartTimer:(NSTimer *)timer
{
    NSTimeInterval timeIntervalTillStartGame = -[[NSDate date] timeIntervalSinceDate:_gameStartTime];
    
    if (timeIntervalTillStartGame > 0)
        self.gameStartTimerLabel.text = [self stringFromTimeInterval:timeIntervalTillStartGame];
    else
    {
        [timer invalidate];
        [self performSelectorOnMainThread:@selector(startGame) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameStartTimerLabel.text = @"--:--:--";
    
    [[TKServer sharedInstance] hello:^(TKGameInfo *gameInfo, NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return;
        }
        
        _gameStartTime = gameInfo.startTime;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runGameStartTimer:) userInfo:nil repeats:YES];
    }];
}


- (IBAction)infoButton:(id)sender {
}


@end
