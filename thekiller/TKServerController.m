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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
        completion(@{ @"gameStartTime": [NSDate date],
                      @"gameName": @"The name of the game",
                      @"gameCreator" : @12345678}, nil);
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


@end
