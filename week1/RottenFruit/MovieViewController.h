//
//  MovieViewController.h
//  RottenFruit
//
//  Created by Shu-Yen Chang on 6/12/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController


@property (strong, nonatomic) NSDictionary *movie;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;

@property (weak, nonatomic) IBOutlet UITabBar *mainTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *boxOfficeItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *DVDItem;

@end
