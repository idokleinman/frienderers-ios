//
//  TKInfoScreenViewController.m
//  Frienderers
//
//  Created by Ido on 25/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKInfoScreenViewController.h"

@interface TKInfoScreenViewController ()

@end

@implementation TKInfoScreenViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
