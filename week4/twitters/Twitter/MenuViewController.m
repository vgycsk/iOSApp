//
//  MenuViewController.m
//  Twitter
//
//  Created by Shu-Yen Chang on 7/4/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ContainerViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "AccountsViewController.h"


@interface MenuViewController ()


@property (strong, nonatomic) ContainerViewController *containerViewController;
@property (strong, nonatomic) TweetsViewController *tweetsViewController;
@property (strong, nonatomic) TweetsViewController *mentionsViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) AccountsViewController *accountsViewController;


@property (strong, nonatomic) UINavigationController *nvc;
@property (strong, nonatomic) NSMutableArray *viewControllers;

@property (weak, nonatomic) User *mainUser;

@property (weak, nonatomic) IBOutlet UIButton *tweetsButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *mentionsButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;



@property (weak, nonatomic) IBOutlet UIImageView *backgroubdImage;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"Menu view");
    
    // Set user profile
    self.mainUser = [User currentUser];
    [self.userPicture setImageWithURL:[NSURL URLWithString:self.mainUser.profileImageUrl]];
    self.userNameLabel.text = self.mainUser.name;
    
    // init controller
    //self.mentionsViewController = [[MentionsViewController alloc] initWithContainerViewController:self.containerViewController];
    self.mentionsViewController = [[[TweetsViewController alloc] initWithAPI:@"mentions" ] initWithContainerViewController:self.containerViewController];
    self.tweetsViewController = [[[TweetsViewController alloc] initWithAPI:@"tweets" ] initWithContainerViewController:self.containerViewController];
    self.profileViewController = [[ProfileViewController alloc] initWithContainerViewController:self.containerViewController];
    [self.profileViewController setUser:[User currentUser]];
    
    self.accountsViewController = [[AccountsViewController alloc] initWithContainerViewController:self.containerViewController];
    [self.accountsViewController setUser:[User currentUser]];
    
    // Default view : home timeline
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.tweetsViewController];
    [self.containerViewController displayContentController:self.nvc];
    
    self.viewControllers = [NSMutableArray arrayWithArray:[self.nvc viewControllers]];
    
    // Set button style
    [self setButtonStyle:self.tweetsButton];
    [self setButtonStyle:self.profileButton];
    [self setButtonStyle:self.mentionsButton];
    [self setButtonStyle:self.accountButton];
    [self.logoutButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"snowy.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    

}

- (void) setButtonStyle:(UIButton *) button{
    [button.layer setBorderWidth:2.0];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [button.layer setCornerRadius:10];
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


- (MenuViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController {
    self = [super init];
    if (self) {
        self.containerViewController = containerViewController;
    }
    return self;
}

#pragma mark - Button Methods
- (IBAction)tweetsButton:(id)sender {
    self.containerViewController.isMenuVisible = NO;
    [self.viewControllers replaceObjectAtIndex:0 withObject:self.tweetsViewController];
    [self.nvc setViewControllers:self.viewControllers];
    [self.nvc popToRootViewControllerAnimated:YES];
    [self.containerViewController toggleMenu];
}

- (IBAction)profileButton:(id)sender {
    self.containerViewController.isMenuVisible = NO;
    [self.viewControllers replaceObjectAtIndex:0 withObject:self.profileViewController];
    [self.nvc setViewControllers:self.viewControllers];
    [self.nvc popToRootViewControllerAnimated:YES];
    [self.containerViewController toggleMenu];
}

- (IBAction)mentionsButton:(id)sender {
    self.containerViewController.isMenuVisible = NO;
    [self.viewControllers replaceObjectAtIndex:0 withObject:self.mentionsViewController];
    [self.nvc setViewControllers:self.viewControllers];
    [self.nvc popToRootViewControllerAnimated:YES];
    [self.containerViewController toggleMenu];
}

- (IBAction)userLogoutButton:(id)sender {
    [User logout];
}

- (IBAction)accountButton:(id)sender {
    self.containerViewController.isMenuVisible = NO;
    [self.viewControllers replaceObjectAtIndex:0 withObject:self.accountsViewController];
    [self.nvc setViewControllers:self.viewControllers];
    [self.nvc popToRootViewControllerAnimated:YES];
    [self.containerViewController toggleMenu];
}
@end
