//
//  MovieViewController.m
//  RottenFruit
//
//  Created by Shu-Yen Chang on 6/12/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "DetailViewController.h"
#import "ErrorView.h"
#import "MovieViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface MovieViewController () <UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property UIRefreshControl *refreshControl;
@property NSString *rottenTomatoesUrl;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];

    // Set the tab bar item
    self.boxOfficeItem.image = [[UIImage imageNamed:@"BoxIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.boxOfficeItem.selectedImage = [[UIImage imageNamed:@"BoxIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];;
    self.DVDItem.image = [[UIImage imageNamed:@"DVDIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.DVDItem.selectedImage = [[UIImage imageNamed:@"DVDIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    self.mainTabBar.delegate = self;
    [self.mainTabBar setSelectedItem:[self.mainTabBar.items objectAtIndex:0]];
    self.title = @"Box Office";
    self.rottenTomatoesUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5";
    
    //Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    //Search bar
    self.movieSearchBar.delegate = self;
    
    // Wait and load data
    [SVProgressHUD show];
    
    [self reloadData];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag==0)
    {
        self.rottenTomatoesUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5";
        self.title = @"Box Office";
        [self reloadData];
    }
    else
    {
        self.rottenTomatoesUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5";
        self.title = @"DVD";
        [self reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *posterURL = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURL]];
  
    cell.posterView.alpha = 0.0;
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:2.0];
    cell.posterView.alpha = 1.0;
    [UIView commitAnimations];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieCell *cell = sender;
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailViewController *destinationVC = segue.destinationViewController;
    destinationVC.movie = movie;
    
}

- (void) reloadData
{
    NSString *apiUrl = self.rottenTomatoesUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            [SVProgressHUD dismiss];
            CGRect rect = CGRectMake(0,0,20,20);
            ErrorView *errorView = [[ErrorView alloc] initWithFrame:rect];
            [self.view addSubview:errorView];
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = dict[@"movies"];
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    self.movieSearchBar.showsCancelButton = YES;
    self.movieSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.movieSearchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.movieSearchBar resignFirstResponder];
     self.movieSearchBar.text = @"";
    [SVProgressHUD show];
    [self reloadData];
    [self.tableView reloadData];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqual:@""]) {
        [self reloadData];
    }
    else
    {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
        self.movies = [self.movies filteredArrayUsingPredicate:searchPredicate];
        
        [self.tableView reloadData];
    }
}


@end
