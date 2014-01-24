//
//  TKNearByDevicesDataSource.h
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKBluetoothManager.h"

@interface TKNearByDevicesDataSource : NSObject <UITableViewDataSource>

- (id)initWithTableView:(UITableView*)tableView;

@end
