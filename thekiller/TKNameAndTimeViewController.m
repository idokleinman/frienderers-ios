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

- (IBAction)inviteButtonPressed:(UIButton *)sender {
    
    if ([self.gameName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a game name" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    } else {
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
                        
                        NSMutableDictionary *p = [urlParams mutableCopy];
                        [p removeObjectForKey:@"request"];
                        
                        TKServer *server = [TKServer sharedInstance];
                        
                        NSMutableArray *players = [[NSMutableArray alloc] initWithArray:p.allValues];
                        [players addObject:server.userid];
                        
                        [server createGameWithTitle:self.gameName.text
                                          startTime:self.datePicker.date
                                      playerUserIDs:players
                                         completion:^(TKGameInfo *game, NSError *error)
                        {
                             if (error) {
                                 [[UIAlertView alertWithError:error] show];
                                 return;
                             }
                             NSLog(@"Game created: %@", game);
                             [AppController() reloadState];
                        }];
                    }
                }
            }
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
