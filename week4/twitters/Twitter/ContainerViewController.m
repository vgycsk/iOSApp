//
//  ContainerViewController.m
//  Twitter
//
//  Created by Su on 7/3/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "AccountsViewController.h"

@interface ContainerViewController ()

@property (strong, nonatomic) UIViewController *contentViewController;

@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) TweetsViewController *tweetsViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) TweetsViewController *mentionsViewController;
@property (strong, nonatomic) AccountsViewController *accountsViewController;

@property (strong, nonatomic) UINavigationController *nvc;


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) UIView *childView;


- (IBAction)onPanContentView:(id)sender;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Container";
    self.contentViewController = nil;
    self.isMenuVisible = YES;
    
    self.menuViewController = [[MenuViewController alloc] initWithContainerViewController:self];
    [self displayMenuContainer];
    //[self displayMentionsContainer];
    //[self displayTweetsContainer];
    //[self displayProfileContainer];
    //self.profileViewController = [[ProfileViewController alloc] init];
    //[self.profileViewController userProfile:nil];
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



#pragma mark - Navigation

- (void) hideChildController:(UIViewController*) content

{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
    
}

- (void)displayMentionsContainer {
    self.mentionsViewController = [[TweetsViewController alloc] initWithContainerViewController:self];
    
    // default view with home timeline
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.mentionsViewController];
    [self displayContentController:self.nvc];
}

- (void)displayMenuContainer {
    self.menuViewController = [[MenuViewController alloc] initWithContainerViewController:self];
    
    [self displayChildController:self.menuViewController containerView:self.menuView];
}

- (void)displayTweetsContainer {
    self.tweetsViewController = [[TweetsViewController alloc] initWithContainerViewController:self];
    
    // default view with home timeline
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.tweetsViewController];
    [self displayContentController:self.nvc];
}

- (void)displayProfileContainer {
    
    self.profileViewController = [[ProfileViewController alloc] initWithContainerViewController:self];
    [self.profileViewController setUser:[User currentUser]];
    // default view with home timeline
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.profileViewController];
    [self displayContentController:self.nvc];
}

- (void) displayChildController:(UIViewController *)child containerView:(UIView *)containerView {
    [self addChildViewController:child];
    child.view.frame = containerView.frame;
    child.view.center = CGPointMake(containerView.center.x,
                                    containerView.center.y);
    [containerView addSubview:child.view];
    [child didMoveToParentViewController:self];
}

- (void) displayContentController:(UIViewController*)content { //
    NSLog(@"Display content controller called with %@", content.class);
    if (self.contentViewController != nil) {
        [self hideChildController:self.contentViewController];
        NSLog(@"hiding %@", self.contentViewController.class);
    }
    self.contentViewController = content;
    
    NSLog(@"Displaying %@", content.class);
    [self displayChildController:content containerView:self.contentView];
}


- (IBAction)onPanContentView:(UIPanGestureRecognizer *)sender {
    
    //NSLog(@"on pan.....");
    self.childView = self.contentView;
    
    CGPoint velocity = [sender velocityInView:self.view];
    
    CGPoint translate = [sender translationInView:self.view];
    CGRect newFrame = self.childView.frame;
    newFrame.origin.x += translate.x;
    newFrame.origin.y += translate.y;
    
    if (sender.state == UIGestureRecognizerStateBegan ) {
        CGPoint transition = [sender locationInView:self.view];
        transition.y = 0;
        self.childView.frame = CGRectMake(transition.x, 0, self.childView.frame.size.width, self.childView.frame.size.height);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (velocity.x >= 20) {
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
                if (velocity.x >= 20) {
                    self.childView.frame = CGRectMake(self.childView.frame.size.width-200, 0, self.childView.frame.size.width, self.childView.frame.size.height);
                }
            } completion:nil];
        } else {
            NSLog(@"velocity %f", velocity.x);
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
                
            } completion:nil];
        }
    }
    
}

- (void)toggleMenu {
    //NSLog(@"toggle menu");
    //NSLog(@"toggle menu %d",self.isMenuVisible );
    self.childView = self.contentView;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
        if (self.isMenuVisible) {
            self.childView.frame = CGRectMake(self.childView.frame.size.width-200, 0, self.childView.frame.size.width, self.childView.frame.size.height);
            self.isMenuVisible = NO;
        } else {
            self.childView.frame = CGRectMake(0, 0, self.childView.frame.size.width, self.childView.frame.size.height);
            self.isMenuVisible = YES;
        }
    } completion:nil];
}

- (void) showLoad {
    
    UIColor *backgroundColor =[UIColor
                               colorWithRed:0.0
                               green:0.0
                               blue:1.0
                               alpha:0.5];
    [SVProgressHUD setBackgroundColor:backgroundColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:(CGFloat)10.0];
    [SVProgressHUD show];
    [SVProgressHUD showWithStatus:@"Loading"];
}

@end
