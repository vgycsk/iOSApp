//
//  MenuViewController.h
//  Twitter
//
//  Created by Shu-Yen Chang on 7/4/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "Tweet.h"

@interface MenuViewController : UIViewController

- (MenuViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController;
@property (nonatomic, strong) Tweet *tweet;


@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@end
