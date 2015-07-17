//
//  PageViewController.h
//  Twitter
//
//  Created by Shu-Yen Chang on 7/8/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@class PageViewController;

@protocol PageViewControllerDelegate <NSObject>


@end


@interface PageViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) id<PageViewControllerDelegate> delegate;
- (id)initWithUser:(User *)currentUser;

@end
