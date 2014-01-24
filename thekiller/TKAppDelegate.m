//
//  TKAppDelegate.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

@import CoreBluetooth;

#import "TKAppDelegate.h"
#import "TKBluetoothManager.h"
#import "TKStyle.h"

@interface TKAppDelegate ()

@property (strong, nonatomic) TKBluetoothManager* bluetooth;
@property (strong, nonatomic) TKServer* server;

@end

@implementation TKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [FBLoginView class];
    [FBProfilePictureView class];
    
    self.bluetooth = [[TKBluetoothManager alloc] init];
    self.server = [[TKServer alloc] init];

    ConfigureAppearnace();
    
    BOOL existingSession = [self.server openSession];
    if (existingSession) {
        self.window.rootViewController = [[self.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"gameWillStartVC"]; //was "main"
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceTokenData {
    NSString* deviceToken = [[[[deviceTokenData description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"remote notif token: %@", deviceToken);
    [self.server registerPushToken:deviceToken];
}

@end

