//
//  ContainerViewController.h
//  Twitter
//
//  Created by Su on 7/3/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>


@interface ContainerViewController : UIViewController


- (void)toggleMenu;
- (void) displayContentController:(UIViewController*)content;

@property (assign, nonatomic) BOOL isMenuVisible;

- (void) showLoad;
@end
