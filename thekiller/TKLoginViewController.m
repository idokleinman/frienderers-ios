//
//  TKLoginViewController.m
//  frienderers
//
//  Created by Elad Ben-Israel on 1/23/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKLoginViewController.h"
#import "UIApplication+TKAppDelegate.h"

@interface TKLoginViewController () <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBLoginView* loginButtonView;

@end

@implementation TKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButtonView.readPermissions = @[ @"basic_info", @"email" ];
    self.loginButtonView.delegate = self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [[UIApplication sharedApplication].tkapp.server openSession];
    [UIApplication sharedApplication].delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

@end