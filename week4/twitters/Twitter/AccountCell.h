//
//  AccountCell.h
//  Twitter
//
//  Created by Shu-Yen Chang on 7/9/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AccountCell : UITableViewCell

@property (nonatomic, strong) User *user;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstraint;

@end
