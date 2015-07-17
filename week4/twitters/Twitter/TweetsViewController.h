//
//  TweetsViewController.h
//  Twitter
//
//  Created by Shu-Yen Chang on 6/28/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "User.h"

@interface TweetsViewController : UIViewController

- (id)initWithAPI:(NSString *)api;
- (TweetsViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController;

@property (nonatomic, strong) User *user;
@end
