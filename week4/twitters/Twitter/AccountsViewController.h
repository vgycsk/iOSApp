//
//  AccountsViewController.h
//  Twitter
//
//  Created by Shu-Yen Chang on 7/9/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "User.h"

@interface AccountsViewController : UIViewController


- (AccountsViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController;
@property (nonatomic, strong) User *user;

@end
