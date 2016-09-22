//
//  Tweet.h
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) Tweet *replyToTweet;

@property (nonatomic) BOOL favorited;
@property (nonatomic) NSInteger favoriteCount;

@property (nonatomic) BOOL retweeted;
@property (nonatomic) NSInteger retweetCount;

@property (nonatomic, strong) NSDate *createdAt;


- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
