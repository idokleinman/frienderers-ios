//
//  TKMainViewController.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/13/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKMainViewController.h"
#import "TKNearByDevicesDataSource.h"

@interface TKBluetoothStatusDataSource : NSObject <UITableViewDataSource>
@property(strong,nonatomic) UITableView* tableView;
@end

@implementation TKBluetoothStatusDataSource

- (id)initWithTableView:(UITableView*)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        [[TKBluetoothManager sharedManager] addObserver:self forKeyPath:@"centralStatus" options:0 context:0];
        [[TKBluetoothManager sharedManager] addObserver:self forKeyPath:@"peripheralStatus" options:0 context:0];
    }
    return self;
}

- (void)dealloc {
    [[TKBluetoothManager sharedManager] removeObserver:self forKeyPath:@"centralStatus" context:0];
    [[TKBluetoothManager sharedManager] removeObserver:self forKeyPath:@"peripheralStatus" context:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title;
    NSString* value;
    
    if (indexPath.row == 0) {
        title = @"Central";
        value = [TKBluetoothManager sharedManager].centralStatus;
    }
    else if (indexPath.row == 1) {
        title = @"Peripheral";
        value = [TKBluetoothManager sharedManager].peripheralStatus;
    }
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = value;
    return cell;
}
@end

@interface TKMainViewController ()

@property (strong, nonatomic) TKNearByDevicesDataSource* nearbyDevicesDataSource;

@end

@implementation TKMainViewController

- (TKBluetoothManager*)bluetooth
{
    return [TKBluetoothManager sharedManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nearbyDevicesDataSource = [[TKNearByDevicesDataSource alloc] initWithTableView:self.tableView];
    self.tableView.dataSource = self.nearbyDevicesDataSource;
}

- (IBAction)logout:(id)sender {
    [[FBSession activeSession] closeAndClearTokenInformation];
    [UIApplication sharedApplication].delegate.window.rootViewController = [self.storyboard instantiateInitialViewController];
}

@end