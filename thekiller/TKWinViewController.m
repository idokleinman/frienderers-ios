//
//  TKWinViewController.m
//  Frienderers
//
//  Created by Ido on 25/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKWinViewController.h"
#import "TKAppViewController.h"

@interface TKWinViewController ()

@end

@implementation TKWinViewController

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
    
    self.headerLabel.attributedText = getAsSmallAttributedString(self.headerLabel.text, NSTextAlignmentCenter);
    self.buttonTitleLabel.attributedText = getAsSmallAttributedString(self.buttonTitleLabel.text, NSTextAlignmentCenter);
}
- (IBAction)continueButtonPressed {
    [AppController() reloadState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
