//
//  ViewController.m
//  TipCaculator
//
//  Created by Shu-Yen Chang on 6/6/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingViewController.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property NSMutableArray *tipValues;

- (IBAction)onTap:(id)sender;
- (void)updateValues;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        self.title = @"Tip Caculator";
    }

    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.tipValues = appDelegate.tipValues;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *stringValue = [defaults objectForKey:@"billAmount"];
    if (stringValue != nil) {
        self.billTextField.text = stringValue;
    }
   
    [self updateValues];
    
    //NSLog(@"%@", appDelegate.tipValues);
    //NSLog(@"viewWillAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (IBAction)changeBillTotal:(id)sender {
    [self updateValues];

}


- (void)updateValues {
    [self.tipControl setTitle:@"123" forSegmentAtIndex:1];
    for(int i = 0; i < self.tipValues.count; i++){
        [self.tipControl setTitle:[NSString stringWithFormat: @"%0.f%%", [self.tipValues[i] floatValue]*100] forSegmentAtIndex:i];
    }
    float billAmount = [self.billTextField.text floatValue];
    float tipAmount = billAmount * [self.tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = tipAmount + billAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.billTextField.text forKey:@"billAmount"];
    [defaults synchronize];
}

#pragma mark - Segues
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPercentage"]) {

    }
    
 
}
*/

- (void)dealloc
{
    // Remove the application life-cycle observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}
@end
