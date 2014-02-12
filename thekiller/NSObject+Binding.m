//
//  NSObject+Binding.m
//  clutils
//
//  Created by Elad Ben-Israel on 12/17/13.
//  Copyright (c) 2013 Citylifeapps. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Binding.h"

@interface CLObserver : NSObject
@property (assign, nonatomic) id observable; // we don't want a zeroing weak reference so we can remove the observer in `dealloc`
@property (copy, nonatomic) NSString* keyPath;
@property (copy, nonatomic) void(^block)(id value);
@end

@interface CLObservable : NSObject
@property (weak, nonatomic) CLObserver* associatedObserver;
@end

@implementation NSObject (Binding)

- (void)addObserver:(NSObject *)observer forKeyPaths:(NSArray*)keyPaths callback:(void(^)(void))block {
    for (NSString* keyPath in keyPaths) {
        [self addObserver:observer forKeyPath:keyPath callback:^(id value) {
            if (block) {
                block();
            }
        }];
    }
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath callback:(void(^)(id value))block {
    // create an object that will serve as the actual observer and associate it with the `observer` itself
    // so their lifetime will be bound. do not retain the observable (self), so could get deallocated freely.
    CLObserver* associatedObserver = [[CLObserver alloc] init];
    associatedObserver.keyPath = keyPath;
    associatedObserver.block = block;
    associatedObserver.observable = self;

    // bind the associated observable and observer together so that when either the observer or observable
    // objects are deallocated, the observation will be removed.
    CLObservable* associatedObservable = [[CLObservable alloc] init];
    associatedObservable.associatedObserver = associatedObserver;
    
    // bind the associated objects to their respective actual objects
    // (we use the addresses of the objects as keys)
    objc_setAssociatedObject(observer, (__bridge const void*)associatedObserver, associatedObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void*)associatedObservable, associatedObservable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation CLObserver

- (void)dealloc {
    self.observable = nil; // remove observation
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) {
        return; // no callback
    }
    
    // call block on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.block(change[NSKeyValueChangeNewKey]);
    });
}

// this is where a lot of the magic happens, basically any assignment to `observable` will
// update the observation lifetime. assigning `nil` here will simply remove the observation.
- (void)setObservable:(id)observable {
    [_observable removeObserver:self forKeyPath:self.keyPath];
    [observable addObserver:self forKeyPath:self.keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
    _observable = observable;
}

@end

@implementation CLObservable

- (void)dealloc {
    // the observable is deallocating, so we need to deassociate it from the observer
    // so that the observation will be removed.
    self.associatedObserver.observable = nil;
}

@end
