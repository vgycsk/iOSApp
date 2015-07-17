//
//  ComposeViewController.m
//  Twitter
//
//  Created by Su on 6/30/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"


@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    // navigation bar
    [self setupNavigationBar];
    
    // setup user
    User *currentUser = User.currentUser;
    [self.profilePicture setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl] placeholderImage:[UIImage imageNamed:@"twitter_profile_pic_48x48"]];
    self.profilePicture.layer.cornerRadius = 3;
    self.profilePicture.clipsToBounds = YES;
    self.username.text = currentUser.name;
    self.screenName.text = currentUser.screenName;
    

    self.textField.delegate = self;
    
    // reply
    if (self.replyToTweet != nil) {
        self.textField.text = [NSString stringWithFormat:@"@%@ ", self.replyToTweet.user.screenName];

        self.textField.selectedRange = NSMakeRange([self.textField.text length], 0);
        self.characterCount.text = [NSString stringWithFormat:@"%ld", 140 - self.textField.text.length];
        [self.textField becomeFirstResponder];
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

- (void)setupNavigationBar{
    UIColor *twitterColor = [UIColor blueColor];
    UIColor *twitterSecondaryColor = [UIColor whiteColor];
    
    self.title = @"Compose";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Close_Window-32"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Send_File-32"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onSend:)];self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = twitterColor;
    self.navigationController.navigationBar.tintColor = twitterSecondaryColor;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:twitterSecondaryColor}];
}

#pragma mark - User Actions

- (void)textViewDidChange:(UITextView *)textView {
    self.characterCount.text = [NSString stringWithFormat:@"%ld", 200 - textView.text.length];
}

- (void) onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSend:(id)sender {
    
    Tweet *newTweet = [Tweet createNewTweetWithText:self.textField.text andReplyID:self.replyToTweet];
    

    if (self.delegate) {
        [self.delegate ComposeViewController:self tweeted:newTweet];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
