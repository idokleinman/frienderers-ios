//
//  TKSoundManager.h
//  Frienderers
//
//  Created by Idan Buberman on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TKSoundManager : NSObject


+ (TKSoundManager *) sharedManager;

- (void) playSound:(NSString *)Name;
-(void) playSoundInBackground:(NSString *)Name;
-(void) stopSoundInBackground;

@end
