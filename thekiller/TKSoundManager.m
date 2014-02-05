//
//  TKSoundManager.m
//  Frienderers
//
//  Created by Idan Buberman on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKSoundManager.h"

@interface TKSoundManager()

@property (strong,nonatomic) AVAudioPlayer *audioPlay;
@property (strong,nonatomic) AVAudioPlayer *audioBackgroundPlay;


@end

@implementation TKSoundManager



static TKSoundManager *sharedManager = nil;

+ (TKSoundManager *) sharedManager
{
    if (!sharedManager)
    {
        sharedManager = [[TKSoundManager alloc] init];
    }
    return sharedManager;
}


- (void) playSound:(NSString *)Name
{
    NSURL *localSoundURL = [[NSBundle mainBundle] URLForResource:Name withExtension:@"mp3"];
    
    NSData *localSoundData = [[NSData alloc] initWithContentsOfURL:localSoundURL];
    
    _audioPlay = [[AVAudioPlayer alloc] initWithData:localSoundData error:NULL];
    
    //    if (loop)
    //        [_audioPlay setNumberOfLoops:-1];
    //    else
    [_audioPlay setNumberOfLoops:0];
    [_audioPlay prepareToPlay];
    
    [_audioPlay play];
}

-(void)playSoundInBackground:(NSString *)Name
{
    NSURL *localSoundURL = [[NSBundle mainBundle] URLForResource:Name withExtension:@"mp3"];
    
    NSData *localSoundData = [[NSData alloc] initWithContentsOfURL:localSoundURL];
    
    if (!_audioBackgroundPlay)
        _audioBackgroundPlay = [[AVAudioPlayer alloc] initWithData:localSoundData error:NULL];
    
    [_audioBackgroundPlay setNumberOfLoops:-1];
    [_audioBackgroundPlay prepareToPlay];
    
    [_audioBackgroundPlay play];
}

-(void)stopSoundInBackground
{
    if (_audioBackgroundPlay)
        [_audioBackgroundPlay stop];
    
}
@end