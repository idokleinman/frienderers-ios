//
//  TKTesterViewController.m
//  Frienderers
//
//  Created by Elad Ben-Israel on 2/5/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKTesterViewController.h"
#import "TKServer.h"

@interface TKTesterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSArray* games;
@property (strong, nonatomic) NSArray* users;
@property (assign, nonatomic) NSInteger selectedGameIndex;
@property (assign, nonatomic) NSInteger selectedUserIndex;
@end

@implementation TKTesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedGameIndex = -1;
    self.selectedUserIndex = -1;
    
    [[TKServer sharedInstance] allGames:^(NSArray *games, NSError *error) {
        if (error) {
            [[UIAlertView alertWithError:error] show];
            return;
        }
        
        self.games = games;
        [self.tableView reloadData];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.games.count;
    }
    
    if (section == 1) {
        return self.users.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* value;
    BOOL isSelected;
    
    if (indexPath.section == 0) {
        value = self.games[indexPath.row];
        isSelected = (self.selectedGameIndex == indexPath.row);
    }
    
    if (indexPath.section == 1) {
        value = self.users[indexPath.row];
        isSelected = (self.selectedUserIndex == indexPath.row);
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = isSelected ? [UIColor greenColor] : [UIColor clearColor];
    cell.textLabel.text = value;
    cell.detailTextLabel.text = isSelected ? @"YES" : @"NO";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // select game
        self.selectedGameIndex = indexPath.row;
        [self.tableView reloadData];
        
        NSString* gameID = self.games[indexPath.row];
        
        [[TKServer sharedInstance] detailsForGameID:gameID completion:^(TKGameInfo *gameInfo, NSError *error) {
            if (error) {
                [[UIAlertView alertWithError:error] show];
                return;
            }
            
            NSLog(@"game info: %@", gameInfo);
            self.users = gameInfo.invited;
            [self.tableView reloadData];
        }];

        
        return;
    }

    if (indexPath.section == 1) { // select user
        self.selectedUserIndex = indexPath.row;
        [self.tableView reloadData];
        return;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Games";
    }
    else {
        return @"Users";
    }
}

@end
