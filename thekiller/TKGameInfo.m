//
//  TKGameInfo.m
//  Frienderers
//
//  Created by Elad Ben-Israel on 1/25/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKGameInfo.h"

@interface TKGameInfo ()

@property (strong, nonatomic) NSDictionary* dict;

@end

@implementation TKGameInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.dict = dict;
    }
    return self;
}

- (NSString *)title { return self.dict[@"title"]; }
- (NSDate *)startTime { return [NSDate dateWithTimeIntervalSinceReferenceDate:[self.dict[@"start"] doubleValue]]; }
- (NSString *)creatorID { return self.dict[@"creator"]; }
- (NSArray *)players { return self.dict[@"players"]; }
- (NSArray *)invited { return self.dict[@"invited"]; }
- (NSArray*)joined { return self.dict[@"joined"]; }
- (NSArray *)rejected { return self.dict[@"rejected"]; }
- (NSDictionary *)killList { return self.dict[@"kill_list"]; }

@end
