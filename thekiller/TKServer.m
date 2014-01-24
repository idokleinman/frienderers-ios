//
//  TKServer.m
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKServer.h"
#import <AFNetworking/AFNetworking.h>

@interface NSData (UTF8)

- (NSString*)UTF8String;

@end

@interface TKServer ()

@property (strong, nonatomic) NSString* userid;
@property (strong, nonatomic) NSDictionary* profile;

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
//    return @"localhost";
    return @"frienderers.com";
}

- (NSString*)domainURLPostfix {
//    return @":5000";
    return @"";
}

- (NSURL*)URLWithPath:(NSString*)path {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", [self domainName], [self domainURLPostfix]]];
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
    
//#ifdef DEBUG
//    [self registerPushToken:@"ff1cb8fb9b49794dc6268a5b28132496257e19b611b046a7abe1c458294e0d7d"];
//#endif
//    [self createGameWithTitle:@"GAME_TITLE" startTime:[NSDate date] playerUserIDs:@[ @"1234", @"3333" ] completion:^(NSDictionary* game, NSError *error) {
//        NSLog(@"created game: %@", game);
//    }];
    [self hello:^(NSDictionary *existingGame, NSError *error) {
        NSLog(@"existingGame: %@", existingGame);
    }];
    
    return YES;
}

- (void)hello:(void(^)(NSDictionary* existingGame, NSError* error))completion {
    NSURLRequest* req = [NSURLRequest requestWithURL:[self URLWithPath:@"/hello"]];
    [self request:req completion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        self.profile = response[@"profile"];
        self.userid = response[@"userid"];
        
        NSLog(@"loggin with with userid %@", self.userid);
        NSLog(@"facebook profile: %@", self.profile);
        
        completion(response[@"existing-game"], nil);
    }];
}

- (void)registerPushToken:(NSString*)deviceToken {
    NSString* path = [NSString stringWithFormat:@"/push_token?token=%@", deviceToken];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[self URLWithPath:path]];
    request.HTTPMethod = @"POST";
    
    [self request:request completion:^(id response, NSError *error) {
        NSLog(@"Push token response: %@", response);
    }];
}

- (void)createGameWithTitle:(NSString*)title startTime:(NSDate*)startTime playerUserIDs:(NSArray*)players completion:(void(^)(NSDictionary* game, NSError* error))completion {
    NSString* url = [[self URLWithPath:@"/game"] absoluteString];
    NSDictionary* params = @{ @"title": title,
                              @"players": players,
                              @"start": @([startTime timeIntervalSinceReferenceDate]) };
    
    NSMutableURLRequest* req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    [self request:req completion:^(id response, NSError* error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSLog(@"Create game response: %@", response);
        completion(response, nil);
    }];
}

- (void)request:(NSURLRequest*)request completion:(void(^)(id response, NSError* error))completion {
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode != 200) {
            NSString* s = [data UTF8String];
            if (s.length == 0) {
                s = @"Request Failed";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, MakeError(s, httpResponse.statusCode));
            });
            return;
        }
        
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(obj, nil);
        });
    }] resume];
}

NSError* MakeError(NSString* desc, NSInteger code) {
    NSString* f = [NSString stringWithFormat:@"%d: %@", code, desc];
    NSError* error = [NSError errorWithDomain:@"TKServer" code:0 userInfo:@{ NSLocalizedDescriptionKey: f }];
    return error;
}

@end

@implementation NSData (UTF8)

- (NSString *)UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end