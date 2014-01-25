//
//  UIAlertView+alertWithError.h
//  Frienderers
//
//  Created by Elad Ben-Israel on 1/25/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (alertWithError)

+ (UIAlertView*)alertWithError:(NSError*)error;

@end
