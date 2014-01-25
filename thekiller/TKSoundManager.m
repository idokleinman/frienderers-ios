//
//  TKSoundManager.m
//  Frienderers
//
//  Created by Idan Buberman on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKSoundManager.h"

@implementation TKSoundManager

static TKSoundManager *sharedSound = nil;

+ (TKSoundManager *) sharedSound
{
    if (!sharedSound)
    {
        sharedSound = [[TKSoundManager alloc] init];
    }
    return sharedSound;
}

- (void) playSound:(NSString *)Name
{
    
    NSURL *localSoundURL = [[NSBundle mainBundle] URLForResource:Name withExtension:@"mp3"];
    
    NSData *localSoundData = [[NSData alloc] initWithContentsOfURL:localSoundURL];
    
    _audioPlay = [[AVAudioPlayer alloc] initWithData:localSoundData error:NULL];
    
    [_audioPlay prepareToPlay];
    
    [_audioPlay play];
}

@end