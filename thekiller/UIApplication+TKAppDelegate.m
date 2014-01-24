//
//  UIApplication+TKAppDelegate.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "UIApplication+TKAppDelegate.h"

@implementation UIApplication (TKAppDelegate)

- (TKAppDelegate *)tkapp {
    return (TKAppDelegate*)self.delegate;
}

@end