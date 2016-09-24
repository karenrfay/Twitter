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

- (NSString *)getRelativeTimestamp {
    NSString *relativeDate;
    NSTimeInterval secondsSinceTweet = -[self.createdAt timeIntervalSinceNow];
    if (secondsSinceTweet < 60) {
        // seconds
        relativeDate = [NSString stringWithFormat:@"%.0fs", secondsSinceTweet];
    } else if (secondsSinceTweet < 3600) {
        // minutes
        relativeDate = [NSString stringWithFormat:@"%.0fm", secondsSinceTweet / 60];
    } else if (secondsSinceTweet < 86400) {
        relativeDate = [NSString stringWithFormat:@"%.0fh", secondsSinceTweet / 3600];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"M/d/yy"];
        relativeDate = [dateFormat stringFromDate:self.createdAt];
    }
    return relativeDate;
}

+ (NSString *)getFormattedCount:(NSInteger)count {
    NSString *str;
    if (count >= 1000000) {
        str = [NSString stringWithFormat:@"%0.2fM", count / 1000000.0];
    } else if (count >= 1000) {
        str = [NSString stringWithFormat:@"%ldK", lroundf(count / 1000.0)];
    } else {
        str = [NSString stringWithFormat:@"%ld", count];
    }
    return str;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject: [[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
