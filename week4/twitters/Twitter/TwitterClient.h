//
//  TwitterClient.h
//  Twitter
//
//  Created by Su on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager


+ (TwitterClient *) sharedInstance;

- (void)logWithCompletion:(void (^)(User *usr, NSError *error)) competion;
- (void)loginWithScreenName:(NSString *)name completion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void) homeTimelineWithParams: (NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void) userTimelineWithParams:(NSDictionary *)params forUser:(User *)user completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void) mentionsTimeline:(NSDictionary *)params forUser:(User *)user completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deleteTweet:(NSString *)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favorite:(NSString *)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unfavorite:(NSString *)tweetID completion:(void (^)(Tweet *tweet, NSError *error))completion;
@end
