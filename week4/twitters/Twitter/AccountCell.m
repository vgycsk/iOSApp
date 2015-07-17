//
//  AccountCell.m
//  Twitter
//
//  Created by Shu-Yen Chang on 7/9/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "AccountCell.h"
#import "UIImageView+AFNetworking.h"


@interface AccountCell ()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;


@end

@implementation AccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUser:(User *)user {
    [self.userPhoto setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.userPhoto.layer.cornerRadius = 10;
    self.userPhoto.layer.borderColor = [[UIColor blueColor] CGColor];
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.clipsToBounds = YES;
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;

    //self.containerView.backgroundColor = [UIColor blueColor];

}

@end
