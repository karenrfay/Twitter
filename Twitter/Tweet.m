//
//  Tweet.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.idStr = dictionary[@"id_str"];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];

        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];

        NSArray *media = [dictionary[@"media"] array];
        if (media && media.count) {
            self.imageUrl = media[0][@"media_url_https"];
        }
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject: [[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
