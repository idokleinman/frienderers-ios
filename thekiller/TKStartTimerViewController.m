//
//  TKStartTimerViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKStartTimerViewController.h"
#import "TKServer.h"
#import "TKSoundManager.h"
#import "TKAppViewController.h"

@interface TKStartTimerViewController ()

//@property (strong, nonatomic) TKGameInfo* gameInfo;

@end

@implementation TKStartTimerViewController

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

- (void)startGame
{
    // let server know game is started
    [[TKServer sharedInstance] startGame:[TKServer sharedInstance].game.gameID completion:^(BOOL started, NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return;
        }
        
        if (!started) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No one joined your game dude", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Restart", nil) otherButtonTitles:nil] show];
            return;
        }
    }];
}

- (void)runGameStartTimer:(NSTimer *)timer
{
    NSTimeInterval timeIntervalTillStartGame = -[[NSDate date] timeIntervalSinceDate:[TKServer sharedInstance].game.startTime];
    
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
    
    self.gameStartTimerLabel.text = nil;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runGameStartTimer:) userInfo:nil repeats:YES];
}


- (IBAction)infoButton:(id)sender {
}


@end
