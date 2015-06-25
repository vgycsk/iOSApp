//
//  FiltersViewController.m
//  Yelp
//
//  Created by Su on 6/21/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "Filters.h"
#import <SVProgressHUD.h>

@interface FiltersViewController () <UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSMutableSet *categories;
@property (nonatomic, strong) NSMutableSet *sort;
@property (nonatomic, strong) NSMutableSet *radius;
@property (nonatomic, strong) NSMutableSet *deal;
@property(nonatomic, strong) NSMutableDictionary *isExpandSection;
@property (nonatomic, strong) Filters *allFilters;


- (void)collapseSection:(NSInteger)section withRow: (NSInteger) row;
- (void)expandSection:(NSInteger)section;
- (BOOL)isExpandSection:(NSInteger)section;

@end


@implementation FiltersViewController

NSInteger areaNumberWithCategories = 3;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self ) {
        self.isExpandSection = [NSMutableDictionary dictionary];
        self.categories = [NSMutableSet set];
        self.deal = [NSMutableSet set];
        self.radius = [NSMutableSet set];
        self.sort = [NSMutableSet set];
        self.allFilters = [[Filters alloc] initAllFilters];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor],
                                     NSForegroundColorAttributeName,
                                     [UIColor whiteColor],
                                     NSBackgroundColorAttributeName,
                                     nil
                                   ];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = @"Filters";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil]forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    
    if ([self getDefaultSetting:@"saveCategories"] != nil) {
        self.categories = [self getDefaultSetting:@"saveCategories"];
    }
    if ([self getDefaultSetting:@"saveDeal"] != nil) {
        self.deal = [self getDefaultSetting:@"saveDeal"];
    }
    if ([self getDefaultSetting:@"saveRadius"] != nil) {
        self.radius = [self getDefaultSetting:@"saveRadius"];
    }
    if ([self getDefaultSetting:@"saveSort"] != nil) {
        self.sort = [self getDefaultSetting:@"saveSort"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 


#pragma mark - Filter method
-(id) getDefaultSetting:(NSString*) forKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSData *data = [defaults objectForKey:forKey];
    if (data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return nil;
    }
    
}

#pragma mark - Table View method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allFilters allFilters].count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor
                      colorWithRed:1.0
                      green:0.0
                      blue:1.0
                      alpha:0.5];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [[self.allFilters allFilters] objectAtIndex:section];
    NSInteger expandSectionCount = [[[self.allFilters allContents] objectForKey:key] count];
    
    if ([key isEqualToString:@"Categories"]) {
        if ([self isExpandSection:section]) {
            return expandSectionCount;
        } else {
            return areaNumberWithCategories+1;
        }
    }
    
    if ([self isExpandSection:section]) {
        return expandSectionCount;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.delegate = self;
    NSInteger section = indexPath.section;
    NSString *sectionTitle = [[self.allFilters allFilters] objectAtIndex:section];
    NSArray *contents = [[self.allFilters allContents] objectForKey:sectionTitle];
    cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    switch (section) {
        case 0:
        case 1:
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                NSString *label;
                NSMutableSet *limitTypeSet;
                
                limitTypeSet = (section == 0) ? self.sort : self.radius;
                
                if ([limitTypeSet count] == 0) {
                    label = contents[0][@"name"];
                } else {
                    for (NSDictionary *sort in limitTypeSet) {
                        label = sort[@"name"];
                    }
                }
                
                if ([self isExpandSection:section]) {
                    cell.textLabel.text = contents[indexPath.row][@"name"];
                
                    if ([label isEqualToString:cell.textLabel.text]) {
                        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ok-25.png"]];
                        return cell;
                    } else {
                        cell.accessoryView = nil;
                        return cell;
                    }
                
                } else {
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Down-25.png"]];
                    cell.textLabel.text = label;
                    return cell;
                }
            }
            
        case 2:
            cell.on = [self.deal containsObject:[contents objectAtIndex:[indexPath row]]];
            return cell;
            
        case 3:
            if (indexPath.row == areaNumberWithCategories  && ![self isExpandSection:section] ) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Down-25.png"]];
                cell.textLabel.text = @"Show all Categories";
                return cell;
            } else {
                cell.on = [self.categories containsObject:[contents objectAtIndex:[indexPath row]]];
                return cell;
            }
            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"No such section" userInfo:nil];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.allFilters allFilters] objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        case 1:
            if ([self isExpandSection:section]) {
                [self collapseSection:section withRow:row];
            } else {
                [self expandSection:section];
            }
            break;
        case 3:
            if (row == areaNumberWithCategories && ![self isExpandSection:section]) {
                [self expandSection:section];
            }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - Switch cell delegate method

- (void) switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [[self.allFilters allFilters] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self.allFilters allContents] objectForKey:key];
    
    if ([key isEqualToString:@"Deals"]) {
        
        if (value) {
            [self.deal addObject:[contents objectAtIndex:[indexPath row]]];
        } else {
            [self.deal removeObject:[contents objectAtIndex:[indexPath row]]];
        }
        
    } else if ([key isEqualToString:@"Categories"]) {
        if (value) {
            [self.categories addObject:[contents objectAtIndex:[indexPath row]]];
        }else {
            [self.categories removeObject:[contents objectAtIndex:[indexPath row]]];
        }
    }
}

#pragma mark - Private method
-(NSDictionary *)filters {

    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    for (NSDictionary *sort in self.sort) {
        [filters setObject:sort[@"code"] forKey:@"sort"];
    }
    for (NSDictionary *radius in self.radius) {
        [filters setObject:radius[@"code"] forKey:@"radius_filter"];
    }
    
    if (self.deal.count > 0) {
        [filters setObject:@"1" forKey:@"deal"];
    }
    if (self.categories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.categories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}

- (void)onCancelButton {
    [self.delegate filtersViewController:self didChangeFilters:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self saveToDefault:self.sort forKey:@"saveSort"];
    [self saveToDefault:self.radius forKey:@"saveRadius"];
    [self saveToDefault:self.deal forKey:@"saveDeal"];
    [self saveToDefault:self.categories forKey:@"saveCategories"];
    
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveToDefault:(id) filter forKey:(NSString*) forKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:filter];
    [defaults setObject:data forKey:forKey];
    [defaults synchronize];
}

- (BOOL)isExpandSection:(NSInteger)section {
    return [self.isExpandSection[@(section)] boolValue];
}

- (void)expandSection:(NSInteger)section {
    self.isExpandSection[@(section)] = @YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)collapseSection:(NSInteger)section withRow: (NSInteger) row {
    
    NSString *sectionTitle = [[self.allFilters allFilters] objectAtIndex:section];
    NSArray *contents = [[self.allFilters allContents] objectForKey:sectionTitle];
    
    switch (section) {
        case 0:
            [self.sort removeAllObjects];
            [self.sort addObject:[contents objectAtIndex:row]];
            break;
            
        case 1:
            [self.radius removeAllObjects];
            [self.radius addObject:[contents objectAtIndex:row]];
            break;
            
        default:
            break;
    }
    
    self.isExpandSection[@(section)] = @NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
