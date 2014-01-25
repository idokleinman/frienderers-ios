//
//  UIAlertView+alertWithError.m
//  Frienderers
//
//  Created by Elad Ben-Israel on 1/25/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "UIAlertView+alertWithError.h"

@implementation UIAlertView (alertWithError)

+ (UIAlertView*)alertWithError:(NSError*)error {
    return [[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
}

@end
