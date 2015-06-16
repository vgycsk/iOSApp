//
//  errorView.m
//  RottenFruit
//
//  Created by Shu-Yen Chang on 6/14/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ErrorView" owner:self options:nil];
        [self addSubview:self.view];
    }
  
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
