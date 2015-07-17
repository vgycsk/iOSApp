//
//  ProfileViewController.m
//  Twitter
//
//  Created by Shu-Yen Chang on 7/7/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ProfileViewController.h"
#import "PageViewController.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "ProfileCell.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate, UIScrollViewDelegate, PageViewControllerDelegate>

@property (weak, nonatomic) ContainerViewController *containerViewController;

@property (assign, nonatomic) BOOL isInfiniteLoading;
@property (assign, nonatomic) BOOL isLoadMore;

@property (strong, nonatomic) NSMutableArray *tweets;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *zoomView;
@property (assign, nonatomic) CGRect cachedImageViewSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userPhotoConstraint;

@end

@implementation ProfileViewController

- (ProfileViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController {
    self = [super init];
    if (self) {
        self.containerViewController = containerViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // table view setup
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self setupTableView];
    
    self.isLoadMore = NO;
    self.isInfiniteLoading = NO;
    //self.user = [User currentUser];
    
    
    // profile picture
    [self.userPhoto setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width / 2;
    self.userPhoto.clipsToBounds = YES;
    
    // cover photo
    if (self.user.profileBannerImageURL != nil) {
        [self.coverPhoto setImageWithURL:[NSURL URLWithString:self.user.profileBannerImageURL]];
    } else {
        [self.coverPhoto setImage:[UIImage imageNamed:@"coverDefault"]];
    }
    
    
    [self userTimeline:nil];
    
    // scroll view
    //[super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    //self.scrollView.delegate = self;
    //[self.view addSubview:self.scrollView];
    
    self.zoomView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.zoomView];
    self.zoomView.backgroundColor = [UIColor clearColor];
    
    [self.view bringSubviewToFront:self.userPhoto];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor *twitterColor = [UIColor blueColor];
    UIColor *twitterSecondaryColor = [UIColor whiteColor];
    
    // navigation bar
    [self setupNavigationBar:twitterColor andTintColor:twitterSecondaryColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = -scrollView.contentOffset.y;
    if (y < 0) {
        return;
    }
    
    if (y > 0) {
        CGFloat newScale = 1 + y / self.cachedImageViewSize.size.height;
        self.zoomView.alpha = (newScale-1)*2;
    
        self.zoomView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width + y, self.cachedImageViewSize.size.height + y);
        self.zoomView.center = CGPointMake(self.view.center.x, 50.0f - scrollView.contentOffset.y/2.0f);
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIImage *blurImage;
    
    //self.scrollView.frame = self.view.bounds;
    //self.scrollView.backgroundColor = [UIColor clearColor];
    //self.view.backgroundColor = [UIColor yellowColor];
    //self.scrollView.alwaysBounceVertical = YES;
    
    self.zoomView.frame = CGRectMake(0, 0, self.coverPhoto.frame.size.width, 100);
    //self.zoomView.backgroundColor = [UIColor redColor];
    
    blurImage = self.coverPhoto.image;
    self.zoomView.image = [self blurredImageWithImage:blurImage];
    self.zoomView.alpha = 0;
    
    
    /* mask
     // create effect
     UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     // add effect to an effect view
     UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
     effectView.frame = self.zoomView.frame;
     // add the effect view to the image view
     [self.zoomView addSubview:effectView];
     */
    
    self.zoomView.contentMode = UIViewContentModeScaleAspectFill;
    self.cachedImageViewSize = self.zoomView.frame;
}

- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Twitter Method
- (void)userTimeline:(NSMutableDictionary *)params {
    
    [[TwitterClient sharedInstance] userTimelineWithParams:nil forUser:self.user completion:^(NSArray *tweets, NSError *error) {
        if (!error) {
            if (self.isInfiniteLoading) {
                [self.tweets addObjectsFromArray:tweets];
            } else {
                //NSLog(@"%@",tweets);
                self.tweets = tweets;
            }
            
            [self.tableView reloadData];
        } else {
            NSLog(@"Failed to get user's timeline in profile view controller");
        }
        
        //debug
        /*
         for (Tweet *tweet in tweets) {
         NSLog(@"text: %@", tweet);
         }
         */
        //[self.tableRefreshControl endRefreshing];
        self.navigationController.navigationBarHidden = NO;
        self.isLoadMore = NO;
        self.isInfiniteLoading = NO;
        
    }];
    
}


#pragma mark - Table Methods
- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

#pragma mark - Navigation Bar
- (void)setupNavigationBar:(UIColor *)barTintColor andTintColor:(UIColor *)tintColor{
    self.title = @"Profile";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"edit-25"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onCompose:)];self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor}];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = barTintColor;
    self.navigationController.navigationBar.backgroundColor = barTintColor;
    
    // Setup menu button
    /*
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Menu-25"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
     */
    if (self.containerViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Menu-25"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    }
}

#pragma mark - Gesture Methods

-(void)tweetCell:(TweetCell *)tweetCell didTapProfilePhoto:(User *)user {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = user;
    [self.navigationController pushViewController:pvc animated:YES];
}




#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1 + self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.user = self.user;
        return cell;
    }
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet =  self.tweets[indexPath.row - 1];
    cell.delegate = self;
    
    // Infinite loading
    if (indexPath.row == self.tweets.count - 1 && !self.isLoadMore) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSInteger max_id = [cell.tweet.tweetID integerValue] - 1;
        [params setObject:@(max_id) forKey:@"max_id"];
        self.isInfiniteLoading = YES;
        [self userTimeline:params];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        PageViewController *pvc = [[PageViewController alloc] initWithUser:self.user];
        //pvc.tweet = self.tweets[indexPath.row];
        //pvc.indexPath = indexPath;
        pvc.delegate = self;
        [self.navigationController pushViewController:pvc animated:YES];
        return;
    }
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.tweet = self.tweets[indexPath.row];
    dvc.indexPath = indexPath;
    dvc.delegate = self;
    [self.navigationController pushViewController:dvc animated:YES];
}


#pragma mark - Button Methods
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

- (void)onMenuButton:(id)sender {
    [self.containerViewController toggleMenu];
}


- (void)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
