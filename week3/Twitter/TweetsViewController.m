//
//  TweetsViewController.m
//  Twitter
//
//  Created by Shu-Yen Chang on 6/28/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TwitterClient.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, DetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property UIRefreshControl *tableRefreshControl;
@property (strong, nonatomic) UINavigationController *nvc;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isInfiniteLoading;

@end


@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    
    // table view setup
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self setupTableView];
    
    // get tweets
    [self homeTimelineWithParams:nil];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    self.isLoadMore = NO;
    self.isInfiniteLoading = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor *twitterColor = [UIColor blueColor];
    UIColor *twitterSecondaryColor = [UIColor whiteColor];
    
    // navigation bar
    [self setupNavigationBar:twitterColor andTintColor:twitterSecondaryColor];
    
     [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    
    // Infinite loading
    if (indexPath.row == self.tweets.count - 1 && !self.isLoadMore) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSInteger max_id = [cell.tweet.tweetID integerValue] - 1;
        [params setObject:@(max_id) forKey:@"max_id"];
        self.isInfiniteLoading = YES;
        [self homeTimelineWithParams:params];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didselectrowatindexpath");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.tweet = self.tweets[indexPath.row];
    dvc.indexPath = indexPath;
    dvc.delegate = self;
    [self.navigationController pushViewController:dvc animated:YES];
}



- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //Refresh control
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onTableRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];

}

- (void)setupNavigationBar:(UIColor *)barTintColor andTintColor:(UIColor *)tintColor{
    self.title = @"Home";
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"edit-25"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onCompose:)];self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];
    
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor}];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = barTintColor;
    self.navigationController.navigationBar.backgroundColor = barTintColor;
}

#pragma mark - Refresh Method
- (void)onTableRefresh:(id)sender {
    [self homeTimelineWithParams:nil];
}

#pragma mark - Twitter Method
- (void)homeTimelineWithParams:(NSDictionary *)params {

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        
        if (self.isInfiniteLoading) {
            [self.tweets addObjectsFromArray:tweets];
        } else {
            self.tweets = tweets;
        }
        //debug
        /*
        for (Tweet *tweet in tweets) {
            NSLog(@"text: %@", tweet.text);
        }
         */
        [self.tableRefreshControl endRefreshing];
        self.navigationController.navigationBarHidden = NO;
        self.isLoadMore = NO;
        self.isInfiniteLoading = NO;
        [self.tableView reloadData];
    }];
    
}

- (void)onCompose:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onReply:(Tweet *)tweet {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.delegate = self;
    cvc.replyToTweet = tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self presentViewController:nvc animated:YES completion:nil];
}


- (void)ComposeViewController:(ComposeViewController *)composeViewController tweeted:(Tweet *)tweet {
    
    [[TwitterClient sharedInstance] tweet:tweet completion:^(Tweet *tweet, NSError *error) {
        // Insert the new tweet to the top
        NSMutableArray *newTweets = [NSMutableArray arrayWithObject:tweet];
        [self.tweets replaceObjectsInRange:NSMakeRange(0,0) withObjectsFromArray:newTweets];
        [self.tableView reloadData];
    }];
}

#pragma mark - User Actions tweetCell
-(void)tweetCell:(TweetCell *)tweetCell didClickReply: (Tweet *) tweet {
    [self onReply:tweet];
}


-(void)tweetCell:(TweetCell *)tweetCell didClickRetweet: (Tweet *) tweet {
    // tweet.retweeted was set to !tweet.retweeted prior to getting here
    if (!tweet.retweeted) {
        [[TwitterClient sharedInstance] deleteTweet:tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"Successfully deleted tweet %@", tweet.text);
                }
                tweetCell.tweet.retweeted = false;
            });
        }];
    } else {
        [[TwitterClient sharedInstance] retweet:tweet completion:^(Tweet *tweet, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"Successfully retweeted tweet %@", tweet.text);
                }
                tweetCell.tweet.retweeted = true;
             });
        }];
    }
    
    // reload the cell
    [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[self.tableView indexPathForCell:tweetCell], nil] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)tweetCell:(TweetCell *)tweetCell didClickFavorite: (Tweet *) tweet {
    // tweet.favorited was set to !tweet.favorited prior to getting here
    if (!tweet.favorited) {
        [[TwitterClient sharedInstance] unfavorite:tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Successfully unfavorited tweet %@", tweet.text);
            }
        }];
    } else {
        [[TwitterClient sharedInstance] favorite:tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Successfully favorited tweet %@", tweet.text);

            }
        }];
    }
    // reload the cell
    [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[self.tableView indexPathForCell:tweetCell], nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - User Actions detailViewController
-(void)detailViewController:(DetailViewController *)controller didClickReply: (Tweet *) tweet {
    [self onReply:tweet];
}

-(void)detailViewController:(DetailViewController *)controller didClickRetweet: (Tweet *) tweet {
    // tweet.retweeted was set to !tweet.retweeted prior to getting here
    if (!tweet.retweeted) {
        [[TwitterClient sharedInstance] deleteTweet:tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
             /*
            dispatch_async(dispatch_get_main_queue(), ^{
                [controller.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet"]];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"Successfully deleted tweet %@", tweet.text);
                }
                controller.retweetCount.text = [NSString stringWithFormat:@"%ld", controller.tweet.retweetCount];
             
            });
              */
        }];
    } else {
        [[TwitterClient sharedInstance] retweet:tweet completion:^(Tweet *tweet, NSError *error) {
            /*
            dispatch_async(dispatch_get_main_queue(), ^{
                [controller.retweetButton.imageView setImage: [UIImage imageNamed:@"retweet_on"]];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"Successfully retweeted tweet %@", tweet.text);
                }
                controller.retweetCount.text = [NSString stringWithFormat:@"%ld", controller.tweet.retweetCount];
                
            });
             */
        }];
    }
    
}


-(void)detailViewController:(DetailViewController *)controller didClickFavorite: (Tweet *) tweet {
    // tweet.favorited was set to !tweet.favorited prior to getting here
    if (!tweet.favorited) {
        [[TwitterClient sharedInstance] unfavorite:tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Successfully unfavorited tweet %@", tweet.text);
            }
        }];
    } else {
        [[TwitterClient sharedInstance] favorite:tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Successfully favorited tweet %@", tweet.text);
                
            }
        }];
    }

}

@end
