//
//  LoginUIViewController.m
//  Twitter
//
//  Created by Su on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "LoginUIViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
@interface LoginUIViewController ()

@end

@implementation LoginUIViewController

- (IBAction)onLogin:(id)sender {

    [[TwitterClient sharedInstance] logWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
            //[self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
            UINavigationController *controller =[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
            [self presentViewController:controller animated:YES completion:nil];

        } else {
            // Present error view
            
        }
        
    }];
    /*
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[TwitterClient sharedInstance] fetchRequestTokenWithPath:@"oauth/request_token"
                              method:@"GET"
                         callbackURL:[NSURL URLWithString:@"cprwitterdemo://oauth"]
                               scope:nil
                             success:^(BDBOAuthToken *requestToken) {
                                 NSLog(@"Got the token");
                                 NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                 
                                 [[UIApplication sharedApplication] openURL:authURL];
                                 //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                 
                                 
                             } failure:^(NSError *error) {
                                 NSLog(@"Failed to get token: %@", error);
                             }];
     
     
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
