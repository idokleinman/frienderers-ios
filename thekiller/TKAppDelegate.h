//
//  TKAppDelegate.h
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBluetoothManager.h"
#import "TKServer.h"

@interface TKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (readonly, nonatomic) TKBluetoothManager* bluetooth;
@property (readonly, nonatomic) TKServer* server;

@end

