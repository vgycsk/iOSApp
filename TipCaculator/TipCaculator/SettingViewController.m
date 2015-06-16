//
//  SettingViewController.m
//  TipCaculator
//
//  Created by Shu-Yen Chang on 6/8/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingViewController.h"


@interface SettingViewController ()
@property NSMutableArray *tipValues;
@property (weak, nonatomic) IBOutlet UITextField *rate1;
@property (weak, nonatomic) IBOutlet UITextField *rate2;
@property (weak, nonatomic) IBOutlet UITextField *rate3;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        self.title = @"Setting";
    }
    self.view.backgroundColor = [UIColor cyanColor];
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.tipValues = appDelegate.tipValues;
    
    self.rate1.text = [NSString stringWithFormat: @"%0.f", [self.tipValues[0] floatValue]*100];
    self.rate2.text = [NSString stringWithFormat: @"%0.f", [self.tipValues[1] floatValue]*100];
    self.rate3.text = [NSString stringWithFormat: @"%0.f", [self.tipValues[2] floatValue]*100];

    // Do any additional setup after loading the view.


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

- (IBAction)saveRate:(id)sender {
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    [appDelegate.tipValues  replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:[self.rate1.text floatValue]/100]];
    [appDelegate.tipValues  replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:[self.rate2.text floatValue]/100]];
    [appDelegate.tipValues  replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:[self.rate3.text floatValue]/100]];
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Modify the Tip Value" delegate:self  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alter show];
}


@end
