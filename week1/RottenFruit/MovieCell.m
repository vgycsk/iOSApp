//
//  MovieCell.m
//  RottenFruit
//
//  Created by Shu-Yen Chang on 6/13/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.posterView.image = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *color = [UIColor blackColor];
    if (highlighted) {
        color = [UIColor redColor];
    }
    self.synopsisLabel.textColor = color;
}
@end
