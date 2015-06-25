//
//  FiltersViewController.h
//  Yelp
//
//  Created by Su on 6/21/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filters.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void) filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;


@end

@interface FiltersViewController : UIViewController

@property (nonatomic,weak) id<FiltersViewControllerDelegate> delegate;


@end
