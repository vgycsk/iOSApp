//
//  TweetCell.m
//  Twitter
//
//  Created by Shu-Yen Chang on 6/29/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()




@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    

    [self.picture setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];

    self.user.text = self.tweet.user.name;
    //self.user.textColor  = [UIColor blueColor];
    
    self.screenName.text = self.tweet.user.screenName;
    self.tweetTime.text = [self getDateString:self.tweet.createdAt];
    self.tweetText.text = self.tweet.text;
    self.retweetCount.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%ld", tweet.favoriteCount];

    
}

- (NSString *)getDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}


#pragma mark - User Actions
- (IBAction)didClickReply:(id)sender {
    if (self.delegate) {
        [self.delegate tweetCell:self didClickReply:self.tweet];
    }
}

- (IBAction)didClickRetweet:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweetCount--;
        
    } else {
        self.tweet.retweetCount++;
    }
    // reload cell
    [self setTweet:self.tweet];
    if (self.delegate){
        [self.delegate tweetCell:self didClickRetweet:self.tweet];
    }

}

- (IBAction)didClickFavorite:(id)sender {
    
    [self setTweet:self.tweet];
    if (self.delegate){
        [self.delegate tweetCell:self didClickFavorite:self.tweet];
    }
}


@end
