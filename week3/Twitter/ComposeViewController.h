//
//  ComposeViewController.h
//  Twitter
//
//  Created by Su on 6/30/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

- (void)ComposeViewController:(ComposeViewController *)composeViewController tweeted:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (strong, nonatomic) Tweet *replyToTweet;

@end
