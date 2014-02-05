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

@property (strong, nonatomic) TKGameInfo* gameInfo;

@end

@implementation TKStartTimerViewController

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

-(void)startGame
{
    // let server know game is started
    [[TKServer sharedInstance] startGame:self.gameInfo.gameID completion:^(NSDictionary *game, NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return;
        }
        
        // perform segue
        NSLog(@"game started");
        [self performSegueWithIdentifier:@"nextTarget" sender:self];
    }];
}

-(void)runGameStartTimer:(NSTimer *)timer
{
    NSTimeInterval timeIntervalTillStartGame = -[[NSDate date] timeIntervalSinceDate:self.gameInfo.startTime];
    
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
        
        [[TKServer sharedInstance] joinGame:^(BOOL success, NSError *error) {
            NSLog(@"JOIN GAME %@ (ERROR: %@)", success ? @"OK" : @"FAIL", error);
        }];
        
        self.gameInfo = gameInfo;
        
        for (NSString *fbid in gameInfo.invited) {
            [AppController() loadProfilePicture:fbid];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runGameStartTimer:) userInfo:nil repeats:YES];
    }];
}


- (IBAction)infoButton:(id)sender {
}


@end
