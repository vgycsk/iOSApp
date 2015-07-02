//
//  TweetCell.h
//  Twitter
//
//  Created by Shu-Yen Chang on 6/29/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


@class TweetCell;

@protocol TweetCellDelegate <NSObject>

-(void)tweetCell:(TweetCell *)tweetCell didClickReply: (Tweet *) tweet;
-(void)tweetCell:(TweetCell *)tweetCell didClickRetweet: (Tweet *) tweet;
-(void)tweetCell:(TweetCell *)tweetCell didClickFavorite: (Tweet *) tweet;


@end

@interface TweetCell : UITableViewCell



@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;



@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *retweeted;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@end
