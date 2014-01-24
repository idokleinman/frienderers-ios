//
//  TKStartTimerViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKStartTimerViewController.h"
#import "TKServerController.h"

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
    // perform segue
    
}

-(void)runGameStartTimer:(NSTimer *)timer
{
    NSTimeInterval timeIntervalTillStartGame = -[[NSDate date] timeIntervalSinceDate:_gameStartTime];
    
    if (timeIntervalTillStartGame > 0)
        self.gameStartTimerLabel.text = [self stringFromTimeInterval:timeIntervalTillStartGame];
    else
        [self performSelectorOnMainThread:@selector(startGame) withObject:nil waitUntilDone:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameStartTimerLabel.text = @"--:--:--";
    
    [[TKServerController sharedServer] loadGameInformation:^(NSDictionary *gameInfo, NSError *error) {
        _gameStartTime = [gameInfo objectForKey:@"gameStartTime"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runGameStartTimer:) userInfo:nil repeats:YES];
        
        [self performSelectorInBackground:@selector(runGameStartTimer:) withObject:nil];
        
        
    }];
     // Do any additional setup after loading the view
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
