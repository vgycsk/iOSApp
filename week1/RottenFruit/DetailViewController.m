//
//  DetailViewController.m
//  RottenFruit
//
//  Created by Shu-Yen Chang on 6/13/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    NSString *posterURL = [self.movie valueForKeyPath:@"posters.detailed"];
    posterURL = [self convertPosterUrlStringToHeighRes:posterURL];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterURL]];
}

- (NSString *)convertPosterUrlStringToHighRes:(NSString *)urlString {
    NSRange range = [urlString rangeOfString:@".*cloundfront.net/" options:NSRegularExpressionSearch];
    NSString *returnValue = urlString;
    if(range.length > 0) {
        returnValue = [urlString stringByReplacingCharactersInRange:range withString:@"https://content5.flixster.com/"];
    }
    return returnValue;
}

- (NSString *)convertPosterUrlStringToHeighRes: (NSString*)urlString {
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *retValue = urlString;
    if (range.length > 0) {
        retValue = [urlString stringByReplacingCharactersInRange:range withString:@"https://content5.flixster.com/"];
    }
    return retValue;
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
