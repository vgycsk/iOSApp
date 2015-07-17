//
//  AccountsViewController.m
//  Twitter
//
//  Created by Shu-Yen Chang on 7/9/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "AccountsViewController.h"
#import "AccountCell.h"
#import "User.h"


@interface AccountsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINavigationController *nvc;
@property (nonatomic, weak) ContainerViewController *containerViewController;


@end

@implementation AccountsViewController

static AccountCell *swipedCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:@"AccountCell"];

    
    //[User addAccount:[User currentUser]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    UIColor *twitterColor = [UIColor blueColor];
    UIColor *twitterSecondaryColor = [UIColor whiteColor];
    
    // navigation bar
    [self setupNavigationBar:twitterColor andTintColor:twitterSecondaryColor];
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

#pragma mark Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    return [User accounts].count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [User accounts].count) {
        UITableViewCell *cell = [UITableViewCell new];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.textLabel.text = @"Switch";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        AccountCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.user = [User accounts][indexPath.row];
        
        cell.removeButton.tag = indexPath.row;
        [cell.removeButton addTarget:self action:@selector(onRemove:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [User accounts].count) {
        [self addAccount];
    } else {
        [self switchAccount:indexPath.row];
    }
}


- (AccountsViewController *)initWithContainerViewController:(ContainerViewController *)containerViewController {
    self = [super init];
    if (self) {
        self.containerViewController = containerViewController;
    }
    return self;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        //[self.dataArray removeObjectAtIndex:indexPath.row];
        User *tempAccount = [[User alloc]init];
        tempAccount= [User accounts][indexPath.row];
        [User removeAccount:tempAccount];
        [tableView reloadData]; // tell table to refresh now
    }
}

#pragma mark - Navigation Bar
- (void)setupNavigationBar:(UIColor *)barTintColor andTintColor:(UIColor *)tintColor{
    self.title = @"Account";
    
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor}];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = barTintColor;
    self.navigationController.navigationBar.backgroundColor = barTintColor;
    
    if (self.containerViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Menu-25"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    }
}

- (void)onMenuButton:(id)sender {
    [self.containerViewController toggleMenu];
}

- (void)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addAccount {
    [User switchUser:nil];
}

- (void)switchAccount:(NSInteger)index {
    [User switchUser:[User accounts][index]];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)onRemove:(UIButton*)sender {
    [User removeAccount:[User accounts][sender.tag]];
    if ([User accounts].count == 0) {
        [User logout];
    }
    [self.tableView reloadData];
}
@end
