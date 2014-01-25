//
//  TKCreateGameViewController.m
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKCreateGameViewController.h"
#import "TKSoundManager.h"


@interface TKCreateGameViewController ()

@end

@implementation TKCreateGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.label setAttributedText:getAsSmallAttributedString(self.label.text, NSTextAlignmentCenter)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createButton:(id)sender {
    [[TKSoundManager sharedManager] playSound:@"create"];
}

@end
