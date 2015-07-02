//
//  Tweet.m
//  Twitter
//
//  Created by Shu-Yen Chang on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        
        NSLog(@"%@", dictionary);
        self.user = [[User alloc] initWithDictionary: dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *createdAtstring = dictionary[@"created_at"];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        formate.dateFormat = @"EEE MMM d HH:mm:ss Z  y";
        
        self.createdAt =  [formate dateFromString:createdAtstring];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.tweetID = dictionary[@"id_str"];
        
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
    }
    
    return self;
}


+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (Tweet *)createNewTweetWithText:(NSString *)text andReplyID: (Tweet *)replyToTweet {
    Tweet *newTweet = [[Tweet alloc] init];
    newTweet.text = text;
    newTweet.replyID = replyToTweet.replyID;
    return newTweet;
}


- (NSDictionary *)convertToAPIDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.text forKey:@"status"];
    if (self.replyID) {
        [result setObject:self.replyID forKey:@"in_reply_to_status_id"];
    }
    return result;
}
@end
