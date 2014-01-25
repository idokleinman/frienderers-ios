//
//  TKServerController.m
//  Frienderers
//
//  Created by Ido on 24/Jan/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKServerController.h"

@interface TKServerController ()

@end

@implementation TKServerController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGameInformation:(void(^)(NSDictionary* gameInfo, NSError* error))completion
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completion(@{ @"gameStartTime": [NSDate dateWithTimeIntervalSinceNow:5.0],
                      @"gameName": @"The name of the game",
                      @"gameCreator" : @12345678}, nil);
    });
}

- (void)loadNextTarget:(void(^)(NSString* nextTargetProfileID, NSError* error))completion
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        NSInteger randomNumber = arc4random() % 10000000;
        NSString *str = [NSString stringWithFormat:@"501317600"];
        completion(str , nil);
    });
}


+(id)sharedServer
{
    static TKServerController *serverController = nil;
    @synchronized(self) {
        if (serverController == nil)
            serverController = [[self alloc] init];
    }
    return serverController;
    
}


-(id)init
{
    self = [super init];
            
    if (self) {
        _myProfileID = @"501317600"; //$$$
    }
    return self;
    
}


@end
