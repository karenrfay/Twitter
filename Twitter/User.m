//
//  User.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end


@implementation User

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if (currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [userDefaults setObject:data forKey:kCurrentUserKey];
    } else {
        [userDefaults setObject:nil forKey:kCurrentUserKey];
    }
}

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }

    return _currentUser;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.summary = dictionary[@"description"];
        self.profileBackgroundColor = [self colorFromString:dictionary[@"profile_background_color"]];
        self.profileLinkColor = [self colorFromString:dictionary[@"profile_link_color"]];
        self.profileBannerUrl = dictionary[@"profile_banner_url"];
        self.profileImageUrl = dictionary[@"profile_image_url_https"];
        self.tagline = dictionary[@"description"];
        self.followingCount = [dictionary[@"friends_count"] integerValue];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
    }
    return self;
}

- (UIColor*)colorFromString:(NSString *)colorStr {
    unsigned colorInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:colorStr];
    [scanner scanHexInt:&colorInt];

    return [UIColor colorWithRed:((float)((colorInt & 0xFF0000) >> 16))/255.0
                           green:((float)((colorInt & 0xFF00) >> 8))/255.0
                            blue:((float)(colorInt & 0xFF))/255.0
                           alpha:1];
}


@end
