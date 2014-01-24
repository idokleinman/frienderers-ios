//
//  TKServer.m
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKServer.h"

@interface NSData (UTF8)

- (NSString*)UTF8String;

@end


@implementation TKServer

- (void)loadGameInformation:(void(^)(NSDictionary* gameInfo, NSError* error))completion {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completion(@{ @"time": [NSDate date],
                      @"name": @"The name of the game" }, nil);
    });
}

- (NSString*)domainName {
    return @"localhost";
}

- (NSURL*)URLWithPath:(NSString*)path {
//    NSURL* url = [NSURL URLWithString:@"http://frienderers.com"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:5000", [self domainName]]];
    return [NSURL URLWithString:path relativeToURL:url];
}

- (BOOL)openSession {
    if (![FBSession openActiveSessionWithAllowLoginUI:NO]) {
        return NO;
    }
    
    NSString* accessToken = [FBSession activeSession].accessTokenData.accessToken;
    NSLog(@"access token: %@", accessToken);

    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"fbtoken" forKey:NSHTTPCookieName];
    [cookieProperties setObject:accessToken forKey:NSHTTPCookieValue];
    [cookieProperties setObject:[self domainName] forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:[self domainName] forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie* cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    // register remote notifications once we set the authentication cookie
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
#ifdef DEBUG
    [self registerPushToken:@"ff1cb8fb9b49794dc6268a5b28132496257e19b611b046a7abe1c458294e0d7d"];
#endif
    
    NSURLRequest* req = [NSURLRequest requestWithURL:[self URLWithPath:@"/me"]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", [data UTF8String]);

    }] resume];
    
    return YES;
}

- (void)registerPushToken:(NSString*)deviceToken {
    NSString* path = [NSString stringWithFormat:@"/push_token?token=%@", deviceToken];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[self URLWithPath:path]];
    request.HTTPMethod = @"POST";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"RESPONSE: %@", [data UTF8String]);
    }] resume];
}

@end

@implementation NSData (UTF8)

- (NSString *)UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end