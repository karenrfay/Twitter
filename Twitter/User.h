//
//  User.h
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) UIColor *profileBackgroundColor;
@property (nonatomic, strong) UIColor *profileLinkColor;
@property (nonatomic, strong) NSString *profileBannerUrl;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic) NSInteger followingCount;
@property (nonatomic) NSInteger followersCount;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
