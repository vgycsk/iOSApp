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
    
    // tap gesture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOnProfilePicture:)];
    [profileTapGestureRecognizer setNumberOfTouchesRequired:1];
    [profileTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.picture addGestureRecognizer:profileTapGestureRecognizer];
    self.userInteractionEnabled = YES;
    self.picture.userInteractionEnabled = YES;
    
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
    
    if (tweet.favorited) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favoriteButton.imageView setImage: [UIImage imageNamed:@"favorite_on"]];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favoriteButton.imageView setImage: [UIImage imageNamed:@"favorite"]];
        });
    }

    
    if (tweet.retweeted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet_on"]];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet"]];
        });
    }
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
        self.tweet.retweeted = false;
        self.tweet.retweetCount--;
        
    } else {
        self.tweet.retweeted = true;
        self.tweet.retweetCount++;
    }
    // reload cell
    [self setTweet:self.tweet];
    if (self.delegate){
        [self.delegate tweetCell:self didClickRetweet:self.tweet];
    }

}

- (IBAction)didClickFavorite:(id)sender {
    
    if (self.tweet.favorited) {
        self.tweet.favorited = false;
        self.tweet.favoriteCount--;
    } else {
        self.tweet.favorited = true;
        self.tweet.favoriteCount++;
    }
    
    [self setTweet:self.tweet];
    // reload cell
    if (self.delegate){
        [self.delegate tweetCell:self didClickFavorite:self.tweet];
    }

}

- (void)didClickOnProfilePicture:(id)sender {
    
    User *user;
    user = self.tweet.user;
    
    [self.delegate tweetCell:self didTapProfilePhoto:user];
}

@end
