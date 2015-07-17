//
//  User.m
//  Twitter
//
//  Created by Shu-Yen Chang on 6/27/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

extern NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
extern NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const UserDidSwitchNotification = @"UserDidSwitchNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;


@end

@implementation User

static User *_currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

- (id)initWithDictionary:(NSDictionary *) dictionary {
    
    self =[super init];
    if (self) {
        self.dictionary =  dictionary;
        self.name = dictionary[@"name"];
        self.userDescription = dictionary[@"description"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.profileBannerImageURL = dictionary[@"profile_banner_url"];
        self.userID = dictionary[@"id_str"];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
        self.isFollowing = ([dictionary[@"following"] integerValue] == 1) ? YES : NO;
        self.followingCount = [dictionary[@"friends_count"] integerValue];
        self.tweetCount = [dictionary[@"listed_count"] integerValue];
        
        
        //NSLog(@"%@", self.userID );
        //NSLog(@"%@", self.userDescription );
    }
    return self;
}


+ (User *) currentUser {
    
    if(_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        
        
        if (data != nil) {
            NSDictionary *dictionary =  [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}


+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data =  [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
       
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: UserDidLogoutNotification object:nil];
}

#pragma mark - account util
NSString * const kAccountsKey = @"kAccountsKey";
static NSMutableArray *_accountsArray = nil;

+ (NSArray *)accounts {
    if (_accountsArray == nil) {
        _accountsArray = [NSMutableArray array];
        NSArray *accounts = [[NSUserDefaults standardUserDefaults] arrayForKey:kAccountsKey];
        for (NSData *data in accounts) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            User *user = [[User alloc] initWithDictionary:dictionary];
            [_accountsArray addObject:user];
        }
        if ([_accountsArray count] == 0) {
            [self addAccount:[self currentUser]];
        }
    }
    return _accountsArray;
}

+ (void)addAccount:(User *)user {
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] arrayForKey:kAccountsKey] mutableCopy];
    
    if (array == nil) {
        array = [NSMutableArray array];
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:user.dictionary options:0 error:&error];
    if (error) {
        NSLog(@"add account error: %@", error);
    }
    [array addObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kAccountsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _accountsArray = [NSMutableArray array];
    for (NSData *data in array) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        User *user = [[User alloc] initWithDictionary:dictionary];
        [_accountsArray addObject:user];
    }
}

+ (void)removeAccount:(User *)user {
    NSInteger remove = -1;
    for (int i = 0; i < _accountsArray.count; i++) {
        if ([user.screenName isEqualToString:((User *)_accountsArray[i]).screenName]) {
            remove = i;
        }
    }
    
    if (remove >= 0) {
        [_accountsArray removeObjectAtIndex:remove];
    }
    
    
    for (User *targetUser in _accountsArray) {
        if ([user.screenName isEqualToString:targetUser.screenName]) {
            [_accountsArray removeObject:targetUser];
        }
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (User *u in _accountsArray) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:u.dictionary options:0 error:&error];
        if (error) {
            NSLog(@"add account error: %@", error);
        }
        [array addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kAccountsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)switchUser:(User *)theUser {
    if ([[self currentUser].screenName isEqualToString:theUser.screenName]) {
        return;
    }
    [[TwitterClient sharedInstance] loginWithScreenName:[theUser.screenName substringFromIndex:1] completion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            [self setCurrentUser:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidSwitchNotification object:nil];
        } else {
            NSLog(@"Error getting user");
        }
    }];
}
@end
