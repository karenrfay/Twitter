//
//  TwitterClient.h
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//


#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "Tweet.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)logout;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)userTimelineWithParams:(NSDictionary *)params user:(User *)user completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)deleteTweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteTweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unfavoriteTweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unretweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)sendTweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;


@end
