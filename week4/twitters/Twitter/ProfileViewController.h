//
//  ProfileViewController.h
//  Twitter
//
//  Created by Shu-Yen Chang on 7/7/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "User.h"

@interface ProfileViewController : UIViewController

- (void)userProfile:(NSDictionary *)params;
- (ProfileViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController;

@property (nonatomic, strong) User *user;

@end
