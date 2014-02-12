//
//  NSObject+Binding.h
//  clutils
//
//  Created by Elad Ben-Israel on 12/17/13.
//  Copyright (c) 2013 Citylifeapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Binding)

- (void)addObserver:(NSObject *)observer forKeyPaths:(NSArray*)keyPaths callback:(void(^)(void))block;
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath callback:(void(^)(id value))block;

@end
