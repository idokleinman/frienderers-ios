//
//  TKGameOverViewController.m
//  Frienderers
//
//  Created by Elad Ben-Israel on 2/12/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKGameOverViewController.h"
#import "TKServer.h"

@interface TKGameOverViewController ()

@end

@implementation TKGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)deleteGame:(id)sender {
    [[TKServer sharedInstance] deleteGame:[TKServer sharedInstance].game.gameID completion:^(NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return ;
        }
        
        NSLog(@"game deleted");
    }];
}

@end
