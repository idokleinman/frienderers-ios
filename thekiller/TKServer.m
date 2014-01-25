//
//  TKServer.m
//  frienderers
//
//  Created by Elad Ben-Israel on 1/24/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "TKServer.h"
#import "AFNetworking.h"

@interface NSData (UTF8)

- (NSString*)UTF8String;

@end

@interface TKServer ()

@property (strong, nonatomic) NSString* userid;
@property (strong, nonatomic) NSDictionary* profile;

@end

@implementation TKServer

+ (TKServer*)sharedInstance {
    static TKServer* i = NULL;
    if (!i) {
        i = [[TKServer alloc] init];
    }
    return i;
}

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
//    return @"frienderers.com";
}

- (NSString*)domainURLPostfix {
    return @":5000";
//    return @"";
}

- (NSURL*)URLWithPath:(NSString*)path {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", [self domainName], [self domainURLPostfix]]];
    path = [NSString stringWithFormat:@"/api%@", path];
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
    
//    
////#ifdef DEBUG
////    [self registerPushToken:@"ff1cb8fb9b49794dc6268a5b28132496257e19b611b046a7abe1c458294e0d7d"];
////#endif
////    [self createGameWithTitle:@"GAME_TITLE" startTime:[NSDate date] playerUserIDs:@[ @"1234", @"3333" ] completion:^(NSDictionary* game, NSError *error) {
////        NSLog(@"created game: %@", game);
////    }];
//    [self hello:^(NSDictionary *existingGame, NSError *error) {
//        NSLog(@"existingGame: %@", existingGame);
//    }];
//    
//    [self createGameWithTitle:@"game_title" startTime:[NSDate date] playerUserIDs:@[ @"620032", @"1234", @"3333" ] completion:^(NSDictionary *game, NSError *error) {
//        NSLog(@"game: %@", game);
//        
//        [self joinGame:^(BOOL success, NSError *error) {
//            if (!success) {
//                NSLog(@"FAILED TO JOIN GAME");
//            }
//            
//            NSLog(@"JOIN");
//            
//            [self startGame:game[@"gameid"] completion:^(NSDictionary *game, NSError *error) {
//                
//                [self shootTarget:@"1234" success:YES nearby:@[@"aaa"] completion:^(NSString *nextTargetID, NSError *error) {
//                    NSLog(@"SHOOT");
//                }];
//            }];
//            
//        }];
//    }];
    
    return YES;
}

- (void)hello:(void(^)(TKGameInfo* existingGame, NSError* error))completion {
    NSURLRequest* req = [NSURLRequest requestWithURL:[self URLWithPath:@"/hello"]];
    [self request:req completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
            completion(nil, error);
            return;
        }
        
        self.profile = response[@"profile"];
        self.userid = response[@"userid"];
        
        NSLog(@"loggin with with userid %@", self.userid);
        NSLog(@"facebook profile: %@", self.profile);
        
        TKGameInfo* gameInfo = [[TKGameInfo alloc] initWithDictionary:response[@"existing-game"]];
        completion(gameInfo, nil);
    }];
}

- (void)nextTarget:(void(^)(NSString* targetUserID, NSError* error))completion {
    NSURLRequest* req = [NSURLRequest requestWithURL:[self URLWithPath:@"/next_target"]];
    [self request:req completion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSLog(@"next taget: %@", response);
        completion(response[@"next_target"], nil);
    }];
}


- (void)startGame:(NSString*)gameid completion:(void(^)(NSDictionary* game, NSError* error))completion {
    NSString* path = [NSString stringWithFormat:@"/games/%@/start", gameid];
    NSString* url = [[self URLWithPath:path] absoluteString];
    NSMutableURLRequest* req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [self request:req completion:^(id response, NSError* error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSLog(@"%@", response);
        completion(response, nil);
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

- (void)joinGame:(void(^)(BOOL success, NSError* error))completion {
    NSString* url = [[self URLWithPath:@"/join"] absoluteString];
    NSMutableURLRequest* req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [self request:req completion:^(id response, NSError* error) {
        if (error) {
            completion(NO, error);
            return;
        }
        
        NSLog(@"Join game response: %@", response);
        completion([response[@"success"] boolValue], nil);
    }];
    
}

- (void)shootTarget:(NSString*)targetID success:(BOOL)success nearby:(NSArray*)nearby completion:(void(^)(NSString* nextTargetID, NSError* error))completion {
    NSString* url = [[self URLWithPath:@"/shoot"] absoluteString];
    NSDictionary* params = @{ @"targetid": targetID,
                              @"is_success": @(success),
                              @"nearby_friends": nearby };
    NSMutableURLRequest* req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    [self request:req completion:^(id response, NSError* error) {
        if (error) {
            completion(NO, error);
            return;
        }
        
        NSLog(@"Shoot response: %@", response);
        completion(response[@"next_target"], nil);
    }];
    
    
}

- (void)createGameWithTitle:(NSString*)title startTime:(NSDate*)startTime playerUserIDs:(NSArray*)players completion:(void(^)(TKGameInfo* game, NSError* error))completion {
    NSString* url = [[self URLWithPath:@"/games"] absoluteString];
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
        TKGameInfo* gameInfo = [[TKGameInfo alloc] initWithDictionary:response];
        completion(gameInfo, nil);
    }];
}

- (void)request:(NSURLRequest*)request completion:(void(^)(id response, NSError* error))completion {
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"API CALL ERROR: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }

        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode != 200) {
            NSString* s = [data UTF8String];
            if (s.length == 0) {
                s = @"Request Failed";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError* e = MakeError(s, httpResponse.statusCode);
                NSLog(@"API ERROR: %@", e);
                completion(nil, e);
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