//
//  User.h
//  Twitter
//
//  Created by Shu-Yen Chang on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;



- (id)initWithDictionary:(NSDictionary *) dictionary;


+ (User *) currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;
@end
