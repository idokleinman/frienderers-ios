//
//  TKAppViewController.h
//  Frienderers
//
//  Created by Amit Attias on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    remoteNotificationKillSucceeded = 1,
    remoteNotificationKillFailed,
    remoteNotificationYouDead,
    remoteNotificationSomeoneDied,
    remoteNotificationSomeoneWin,
    remoteNotificationRunAway,
    remoteNotificationGameBegins,
    remoteNotificationsInviteReceived,
    remoteNotificationsBTClosed
} RemoteNotifications;


@interface TKAppViewController : UIViewController

- (void)reloadState;

@end

extern TKAppViewController* AppController();
