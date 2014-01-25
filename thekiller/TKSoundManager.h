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

@property (strong,nonatomic) AVAudioPlayer *audioPlay;

+ (TKSoundManager *) sharedSound;

- (void) playSound:(NSString *)Name;

@end
