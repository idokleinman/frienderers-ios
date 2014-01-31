//
//  TKNameAndTimeViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKNameAndTimeViewController.h"
#import "TKServer.h"
#import "TKStyle.h"
#import "TKAppViewController.h"

@interface TKNameAndTimeViewController ()

@end

@implementation TKNameAndTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.headerLabel setAttributedText:getAsSmallAttributedString(self.headerLabel.text, NSTextAlignmentLeft)];

    [self.bottomButtonLabel setAttributedText:getAsSmallAttributedString(self.bottomButtonLabel.text, NSTextAlignmentCenter)];
    
    UIColor *color = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self.gameName setBackgroundColor:[UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0]];

    [self.gameName.layer setBorderColor:[UIColor redColor].CGColor];
    [self.gameName.layer setBorderWidth:2.0];
    self.gameName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.gameName.placeholder attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:@"JollyLodger"}];
    self.gameName.delegate = self;
    
    [self.datePicker setMinimumDate:[NSDate date]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.gameName resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)disableKeyboard:(UIButton *)sender {
    [self.gameName resignFirstResponder];
}

- (void)addFriends:(void(^)(NSArray* friends, NSError* error))completion {
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession] message:@"Come play with me" title:@"Frienderers" parameters:nil handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Error launching the dialog or sending the request.
            NSLog(@"Error sending request.");
            completion(nil, error);
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // User clicked the "x" icon
                NSLog(@"User canceled request.");
                completion(@[], nil);
            } else {
                // Handle the send request callback
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                if (![urlParams valueForKey:@"request"]) {
                    // User clicked the Cancel button
                    NSLog(@"User canceled request.");
                    completion(@[], nil);
                } else {
                    // User clicked the Send button
                    NSString *requestID = [urlParams valueForKey:@"request"];
                    NSLog(@"Request ID: %@", requestID);
                    
                    NSMutableDictionary *p = [urlParams mutableCopy];
                    [p removeObjectForKey:@"request"];
                    
                    
                    NSMutableArray *players = [[NSMutableArray alloc] initWithArray:p.allValues];
                    [players addObject:[TKServer sharedInstance].userid];

                    completion(players, nil);
                }
            }
        }
    }];
    
}

- (IBAction)inviteButtonPressed:(UIButton *)sender {
    
    if ([self.gameName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a game name" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    } else {
        self.loadingView.hidden = NO;
        self.loadingView.alpha = 0.0f;

        [UIView animateWithDuration:0.25f animations:^{
            self.loadingView.alpha = 1.0f;
        }];
        
        __weak TKNameAndTimeViewController* myself = self;
        
        [self addFriends:^(NSArray *friends, NSError *error) {
            [[TKServer sharedInstance] createGameWithTitle:myself.gameName.text
                                                 startTime:myself.datePicker.date
                                             playerUserIDs:friends
                                                completion:^(TKGameInfo *game, NSError *error)
             {
                 if (error) {
//                     [[UIAlertView alertWithError:error] show];
                     myself.loadingView.hidden = YES;
                     return;
                 } else {
                     NSLog(@"Game created: %@", game);
                     [AppController() reloadState];
                 }
             }];
        }];

    }
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
