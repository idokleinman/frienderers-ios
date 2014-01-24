//
//  TKNameAndTimeViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKNameAndTimeViewController.h"

@interface TKNameAndTimeViewController ()

@end

@implementation TKNameAndTimeViewController

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
	// Do any additional setup after loading the view.
    

    UIColor *color = [UIColor redColor];
    self.gameName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.gameName.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.datePicker setMinimumDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)disableKeyboard:(UIButton *)sender {
    [self.gameName resignFirstResponder];
}

- (IBAction)inviteButtonPressed:(UIButton *)sender {
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession] message:@"Come play with me" title:@"Frienderers" parameters:nil handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Error launching the dialog or sending the request.
            NSLog(@"Error sending request.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                // Handle the send request callback
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                if (![urlParams valueForKey:@"request"]) {
                    // User clicked the Cancel button
                    NSLog(@"User canceled request.");
                } else {
                    // User clicked the Send button
                    NSString *requestID = [urlParams valueForKey:@"request"];
                    NSLog(@"Request ID: %@", requestID);
                    
                    //TODO: call server and move to next screen
                }
            }
        }
    }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
