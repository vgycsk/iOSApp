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
@property (nonatomic, strong) NSString *profileBannerImageURL;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, assign) BOOL isFollowing;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger tweetCount;

- (id)initWithDictionary:(NSDictionary *) dictionary;


+ (User *) currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;
+ (NSArray *)accounts;
+ (void)addAccount:(User *)user;
+ (void)switchUser:(User *)user;
+ (void)removeAccount:(User *)user;
@end
