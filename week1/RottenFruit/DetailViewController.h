//
//  DetailViewController.h
//  RottenFruit
//
//  Created by Shu-Yen Chang on 6/13/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;


@property (strong, nonatomic) NSDictionary *movie;
@end
