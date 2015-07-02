//
//  TwitterClient.m
//  Twitter
//
//  Created by Su on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString *const kTwitterConsumerKey = @"coqhUqLXuVSz2aIm5hmfJpCHx";
NSString *const kTwitterConsumerSecret = @"SjftlgPEVieFGhEvHdO9DjIHDLmZGv8ssA9dZAq3F0Wwejhhf5";
NSString *const kTwitterBaseUrl = @"https://api.twitter.com";
NSString *const kTwitterAPIUpdate = @"1.1/statuses/update.json";
NSString *const kTwitterAPIRetweet = @"1.1/statuses/retweet/%@.json";
NSString *const kTwitterAPIDelete = @"1.1/statuses/destroy/%@.json";
NSString *const kTwitterAPIFavorite   = @"1.1/favorites/create.json";
NSString *const kTwitterAPIUnFavorite = @"1.1/favorites/destroy.json";

@interface TwitterClient()

@property (nonatomic, strong) void (^logWithCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient



+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            
            instance = [[TwitterClient alloc] initWithBaseURL: [NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
        
    });
    
    static dispatch_once_t pred;
    
    return instance;
    
}

- (void)logWithCompletion:(void (^)(User *usr, NSError *error)) competion {
    
    self.logWithCompletion = competion;
    
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cprwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
            NSLog(@"Got the token");
            NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                                          
            [[UIApplication sharedApplication] openURL:authURL];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                                          
                                                          
         } failure:^(NSError *error) {
             NSLog(@"Failed to get token: %@", error);
             self.logWithCompletion(nil, error);
         }];
}

- (void) openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"Got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"Current user: %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            //NSLog(@"Current user: %@", user);
            [User setCurrentUser:user];
            NSLog(@"current user name: %@", user.name);
            self.logWithCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed getting current user");
            self.logWithCompletion(nil, error);
        }];
        /*
        [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"tweets: %@", responseObject);
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            
            for (Tweet *tweet in tweets) {
                NSLog(@"tweet: %@, created: %@",tweet.text, tweet.createdAt);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed getting tweets");
        }];
        */
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token");
    }];
    
}



- (void) homeTimelineWithParams: (NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        NSLog(@"tweets: %@", responseObject);
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        
        for (Tweet *tweet in tweets) {
            NSLog(@"tweet: %@, created: %@",tweet.text, tweet.createdAt);
        }
         */
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed getting tweets");
        completion(nil, error);
    }];

    
    
}

#pragma mark - Twitter API Actions

- (void)tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:kTwitterAPIUpdate parameters:[tweet convertToAPIDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}



- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:[NSString stringWithFormat:kTwitterAPIRetweet, tweet.tweetID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}


- (void)deleteTweet:(NSString *)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion {

    /*
    if (tweetID == nil) {
        completion(nil, nil);
        return;
    }
     */
    [self POST:[NSString stringWithFormat:kTwitterAPIDelete, tweetID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
    
}

- (void)favorite:(NSString *)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:tweetID, @"id", nil];
    [self POST:kTwitterAPIFavorite parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
    
}

- (void)unfavorite:(NSString *)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:tweetID, @"id", nil];
    [self POST:kTwitterAPIUnFavorite parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}
@end
