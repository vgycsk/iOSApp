//
//  DetailViewController.m
//  Twitter
//
//  Created by Su on 7/1/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.picture setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.user.text = self.tweet.user.name;
    self.screenName.text = self.tweet.user.screenName;
    //self.user.textColor  = [UIColor blueColor];
    
    //self.screenName.text = self.tweet.user.screenname;
    self.tweetTime.text = [self getDateString:self.tweet.createdAt];
    self.tweetText.text = self.tweet.text;
    self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    
    if (self.tweet.favorited) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favoriteButton.imageView setImage: [UIImage imageNamed:@"favorite_on"]];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favoriteButton.imageView setImage: [UIImage imageNamed:@"favorite"]];
        });
    }
    
    
    if (self.tweet.retweeted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet_on"]];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet"]];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSString *)getDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}


#pragma mark - User Actions
- (IBAction)didClickReply:(id)sender {
    if (self.delegate) {
        [self.delegate detailViewController :self didClickReply:self.tweet];
    }
}

- (IBAction)didClickRetweet:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweetCount--;
        self.tweet.retweeted = false;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet"]];
            self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
        });
    } else {
        self.tweet.retweetCount++;
        self.tweet.retweeted = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet_on"]];
            self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
        });
    }
    // reload cell
    [self setTweet:self.tweet];
    if (self.delegate){
        [self.delegate detailViewController:self didClickRetweet:self.tweet];
    }
    
}

- (IBAction)didClickFavorite:(id)sender {
    
    if (self.tweet.favorited) {
        self.tweet.favoriteCount--;
        self.tweet.favorited = false;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favoriteButton.imageView setImage: [UIImage imageNamed:@"favorite"]];
            self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
        });
    } else {
        self.tweet.favoriteCount++;
        self.tweet.favorited = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.favoriteButton.imageView setImage: [UIImage imageNamed:@"favorite_on"]];
            self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
        });
    }
    
    [self setTweet:self.tweet];
    if (self.delegate){
        [self.delegate detailViewController:self didClickFavorite:self.tweet];
    }
}

@end
