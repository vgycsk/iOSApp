//
//  Tweet.h
//  Twitter
//
//  Created by Shu-Yen Chang on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;


- (id)initWithDictionary:(NSDictionary *) dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

+ (Tweet *)createNewTweetWithText:(NSString *)text andReplyID: (Tweet *)replyToTweet;

@property (nonatomic, strong) NSString *replyID;
@property (nonatomic, strong) NSString *tweetID;

@property (nonatomic, strong) Tweet *retweet;

- (NSDictionary *)convertToAPIDictionary;


@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger retweetCount;

@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;

@end
