//
//  DetailViewController.h
//  Twitter
//
//  Created by Su on 7/1/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)detailViewController:(DetailViewController *)detailVC didClickFavorite:(Tweet *)tweet;
- (void)detailViewController:(DetailViewController *)detailVC didClickReply:(Tweet *)tweet;
- (void)detailViewController:(DetailViewController *)detailVC didClickRetweet:(Tweet *)tweet;

@end


@interface DetailViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *screenName;

@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@end