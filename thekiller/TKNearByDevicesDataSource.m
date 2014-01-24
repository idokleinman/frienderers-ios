//
//  TKNearByDevicesDataSource.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKNearByDevicesDataSource.h"
#import "TKAppDelegate.h"

@interface TKNearByDevicesDataSource ()

@property (strong, nonatomic) TKBluetoothManager* manager;
@property (strong, nonatomic) UITableView* tableView;
@end

@implementation TKNearByDevicesDataSource

- (id)initWithTableView:(UITableView*)tableView {
    self = [super init];
    if (self) {
        self.manager = [UIApplication sharedApplication].tkapp.bluetooth;
        self.tableView = tableView;
        [self.manager addObserver:self forKeyPath:@"nearbyDevicesDictionary" options:NSKeyValueObservingOptionInitial context:0];
    }
    return self;
}

- (void)dealloc {
    [self.manager removeObserver:self forKeyPath:@"nearbyDevicesDictionary" context:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.tableView reloadData];
}

#pragma mark - Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.nearbyDevicesDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    NSString* name = self.manager.nearbyDevicesDictionary.allKeys[indexPath.row];
    TKDevice* obj = self.manager.nearbyDevicesDictionary[name];
    cell.textLabel.text = obj.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)obj.rssi];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Nearby devices";
}

@end
