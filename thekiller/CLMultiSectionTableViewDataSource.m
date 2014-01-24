//
//  CLMultiSectionTableViewDataSource.m
//  thekiller
//
//  Created by Elad Ben-Israel on 1/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLMultiSectionTableViewDataSource.h"

@implementation CLMultiSectionTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSources[section] respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.dataSources[section] tableView:tableView numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSources[indexPath.section] respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.dataSources[indexPath.section] tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.dataSources[section] respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self.dataSources[section] tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([self.dataSources[section] respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [self.dataSources[section] tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSources[indexPath.row] respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.dataSources[indexPath.row] tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSources[indexPath.row] respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [self.dataSources[indexPath.row] tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return  nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSources[indexPath.section] respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.dataSources[indexPath.section] tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([self.dataSources[sourceIndexPath.section] respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.dataSources[sourceIndexPath.section] tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

@end
