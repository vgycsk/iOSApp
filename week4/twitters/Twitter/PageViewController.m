//
//  PageViewController.m
//  Twitter
//
//  Created by Shu-Yen Chang on 7/8/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "PageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation PageViewController


- (id)initWithUser:(User *)currentUser {
    
    self = [super init];
    
    if (self)
    {
        self.user = currentUser;
        
    }
    return self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.userPhoto setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width / 2;
    self.userPhoto.clipsToBounds = YES;
    
    self.userNameLabel.text = self.user.name ;
    self.screenNameLabel.text = self.user.screenName;
    
    self.textField.text = self.user.userDescription;
    [self.textField.layer setBorderWidth:3.0];
    [self.textField.layer setBorderColor:[[UIColor grayColor] CGColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
