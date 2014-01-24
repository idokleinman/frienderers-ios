//
//  CLMultiSectionTableViewDataSource.h
//  thekiller
//
//  Created by Elad Ben-Israel on 1/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMultiSectionTableViewDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray* dataSources;

@end
