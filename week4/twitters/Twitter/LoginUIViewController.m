//
//  LoginUIViewController.m
//  Twitter
//
//  Created by Su on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ContainerViewController.h"
#import "LoginUIViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"


@interface LoginUIViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *twitterLogo;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginUIViewController

- (IBAction)onLogin:(id)sender {
    
    
    [self.loginButton setTitle:@"Loading ....." forState:UIControlStateNormal];
    

    [[TwitterClient sharedInstance] logWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
            //[self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];

            [self presentViewController:[[ContainerViewController alloc] init] animated:YES completion:nil];
 
        } else {
            // Present error view
            
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginButton.layer setBorderWidth:3.0];
    [self.loginButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    //[self.loginButton.layer setShadowOffset:CGSizeMake(5, 5)];
    //[self.loginButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
    //[self.loginButton.layer setShadowOpacity:0.5];
    [self.loginButton.layer setCornerRadius:20];

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
