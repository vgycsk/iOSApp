//
//  Filters.h
//  Yelp
//
//  Created by Su on 6/22/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filters : NSObject <NSCopying>

@property(strong, nonatomic) NSMutableArray *allFilters;
@property(strong, nonatomic) NSMutableDictionary *allContents;

- (id) initAllFilters;

@end
