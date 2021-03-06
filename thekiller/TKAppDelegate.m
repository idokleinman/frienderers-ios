//
//  TKAppDelegate.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

@import CoreBluetooth;

#import "NSObject+Binding.h"
#import "TKAppDelegate.h"
#import "TKBluetoothManager.h"
#import "TKStyle.h"
#import "TKServer.h"
#import "TKSoundManager.h"
#import "TKProfilePicturesCache.h"

@interface TKAppDelegate ()

@property (strong, nonatomic) TKAppViewController* appViewController;

@end

@implementation TKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [FBLoginView class];
    
    application.applicationSupportsShakeToEdit = YES;
    
    self.appViewController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"app"];
    
    ConfigureAppearnace();
    
    [self showApplicationViewControllerIfLoggedIn];
    
    [[TKProfilePicturesCache sharedInstance] start];

    [[TKServer sharedInstance] addObserver:self forKeyPath:@"userid" callback:^(id value) {
        // user id changed, if exists, start bluetooth
        if ([TKServer sharedInstance].userid.length > 0) {
            [[TKBluetoothManager sharedManager] startWithName:[TKServer sharedInstance].userid];
        }
    }];
    
    return YES;
}

- (void)showApplicationViewControllerIfLoggedIn {
    if ([[TKServer sharedInstance] openSession]) {
        self.window.rootViewController = self.appViewController;
    }
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
    [AppController() reloadState];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

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
    [[TKServer sharedInstance] registerPushToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"remote notification: %@", userInfo);
    
    RemoteNotifications type = (RemoteNotifications)[userInfo[@"loc-args"][@"type"] intValue];
    
    switch (type) {
        case remoteNotificationGameBegins:
        case remoteNotificationYouDead:
        case remoteNotificationsInviteReceived:
        case remoteNotificationSomeoneWin:
            [AppController() reloadState];
            break;
        case remoteNotificationRunAway:
        case remoteNotificationSomeoneDied:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotificationReceived" object:nil userInfo:userInfo];
            break;
        default:
            break;
    }
    
}

@end

