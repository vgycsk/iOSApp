//
//  ProfileCell.m
//  Twitter
//
//  Created by Su on 7/7/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ProfileCell.h"


@interface ProfileCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;

@end

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUser:(User *)user {
    
    NSLog(@"Displayed profile cell ");
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetCount.text = [NSString stringWithFormat:@"%ld", user.tweetCount];
    self.followingCount.text = [NSString stringWithFormat:@"%ld", user.followingCount];
    self.followerCount.text = [NSString stringWithFormat:@"%ld", user.followersCount];

}

@end
