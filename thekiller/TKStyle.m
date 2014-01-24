//
//  TKStyle.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKStyle.h"

@implementation TKBigLabel : UILabel
@end

@implementation TKSmallLabel : UILabel
@end

@implementation TKView : UIView
@end

@implementation TKButton : UIButton
@end

void ConfigureAppearnace()
{
    [[TKBigLabel appearance] setFont:[UIFont systemFontOfSize:28]];
    [[TKBigLabel appearance] setBackgroundColor:[UIColor clearColor]];
    [[TKBigLabel appearance] setTextColor:[UIColor redColor]];

    [[TKSmallLabel appearance] setFont:[UIFont systemFontOfSize:20]];
    [[TKSmallLabel appearance] setBackgroundColor:[UIColor clearColor]];
    [[TKSmallLabel appearance] setTextColor:[UIColor redColor]];
    
    [[TKView appearance] setBackgroundColor:[UIColor blackColor]];
    
    [[TKButton appearance] setBackgroundColor:[UIColor clearColor]];
    
    
}
