//
//  TKkillTargetViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKKillTargetViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TKShootViewController.h"
#import "TKSoundManager.h"
#import "TKAppViewController.h"

@interface TKKillTargetViewController ()

@property (strong, nonatomic) NSString* nextTargetProfileID;

@end

@implementation TKKillTargetViewController
{
    NSString* _nextTargetProfileID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)targetApproveButton:(id)sender
{
    [[TKSoundManager sharedManager] playSound:@"target"];
    [self performSegueWithIdentifier:@"shoot" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TKShootViewController *svc = [segue destinationViewController];
    svc.targetProfileID = _nextTargetProfileID;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TKSoundManager sharedManager] stopSoundInBackground];
    
    [self.buttonTitle setAttributedText:getAsSmallAttributedString(self.buttonTitle.text, NSTextAlignmentCenter)];
    [self.wantedLabel setFont:[UIFont fontWithName:@"Rosewood" size:67.0]];
    [self.deadOrDeadLabel setFont:[UIFont fontWithName:@"Rosewood" size:35.0]];
    [[TKServer sharedInstance] nextTarget:^(NSString *nextTargetProfileID, NSString *targetName, NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return;
        }

        CGRect frame = self.nextTargetFBProfileImage.frame;
        frame.size.height = 240;
        self.nextTargetFBProfileImage.fbid = nextTargetProfileID;
        [self.nextTargetFBProfileImage setFrame:frame];
        _nextTargetProfileID = nextTargetProfileID;
        
        self.killLabel.attributedText = getAsSmallAttributedString([NSString stringWithFormat:@"Kill %@ before someone else kills you!", targetName], NSTextAlignmentCenter);
    }];
}
     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
