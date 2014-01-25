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
    [[TKBigLabel appearance] setFont:[UIFont fontWithName:@"Rosewood" size:28]];
    [[TKBigLabel appearance] setBackgroundColor:[UIColor clearColor]];
    [[TKBigLabel appearance] setTextColor:[UIColor redColor]];

    [[TKSmallLabel appearance] setFont:[UIFont fontWithName:@"JollyLodger" size:20]];
    [[TKSmallLabel appearance] setBackgroundColor:[UIColor clearColor]];
    [[TKSmallLabel appearance] setTextColor:[UIColor redColor]];
    
    [[TKView appearance] setBackgroundColor:[UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0]];
    
    [[TKButton appearance] setBackgroundColor:[UIColor clearColor]];
    
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
    
}

NSAttributedString *getAsSmallAttributedString(NSString *str, NSTextAlignment alignment)
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0];
    [style setMinimumLineHeight:20];
    [style setMaximumLineHeight:20];
    [style setAlignment:alignment];
    [attString addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, attString.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attString.length)];
    
    [attString addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0,attString.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"JollyLodger" size:20] range:NSMakeRange(0, attString.length)];

    return attString;
}

NSAttributedString *getAsPopupAttributedString(NSString *str, NSTextAlignment alignment)
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0];
//    [style setMinimumLineHeight:80];
    [style setMaximumLineHeight:80];
    [style setAlignment:alignment];
    [attString addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, attString.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attString.length)];
    [attString addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0,attString.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"JollyLodger" size:80.0] range:NSMakeRange(0, attString.length)];
    
    return attString;
}
