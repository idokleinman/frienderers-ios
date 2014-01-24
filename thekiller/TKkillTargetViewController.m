//
//  TKkillTargetViewController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKkillTargetViewController.h"
#import "TKServerController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface TKkillTargetViewController ()

@end

@implementation TKkillTargetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)targetApproveButton:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TKServerController sharedServer] loadNextTarget:^(NSString *nextTargetProfileID, NSError *error) {
        
        //        self.nextTargetFBProfileImage = [[FBProfilePictureView alloc] initWithProfileID:nextTargetProfileID pictureCropping:FBProfilePictureCroppingSquare];
        
        [self.nextTargetFBProfileImage setProfileID:nextTargetProfileID];
        [self.nextTargetFBProfileImage setPictureCropping:FBProfilePictureCroppingSquare];
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@",nextTargetProfileID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
        {
            if (!error)
            {
                // Success! Include your code to handle the results here
                NSLog(@"Next target user info: %@", result);
                self.killLabel.text = [NSString stringWithFormat:@"Kill %@ before someone else kills you!",[result objectForKey:@"first_name"]];
            }
            else
            {
                // An error occurred, we need to handle the error
            }
            
        }];
        
        // Do any additional setup after loading the view.
    }];
}
     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
