//
//  TweetCell.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TweetCell.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@end

@implementation TweetCell

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    self.userNameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    self.tweetTextLabel.text = tweet.text;
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.profileImage.layer.cornerRadius = 5.0;
    self.profileImage.layer.masksToBounds = YES;

    NSTimeInterval secondsSinceTweet = -[tweet.createdAt timeIntervalSinceNow];
    if (secondsSinceTweet < 60) {
        // seconds
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fs", secondsSinceTweet];
    } else if (secondsSinceTweet < 3600) {
        // minutes
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fm", secondsSinceTweet / 60];
    } else if (secondsSinceTweet < 86400) {
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fh", secondsSinceTweet / 3600];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"M/d/yy"];
        self.dateLabel.text = [dateFormat stringFromDate:tweet.createdAt];
    }

    if (tweet.favorited) {
        self.favoriteButton.imageView.image = [UIImage imageNamed:@"favorited"];
    } else {
        self.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite"];
    }
    
    if (tweet.retweeted) {
        self.retweetButton.imageView.image = [UIImage imageNamed:@"retweeted"];
    } else {
        self.retweetButton.imageView.image = [UIImage imageNamed:@"retweet"];
    }
}

- (IBAction)onTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [[TwitterClient sharedInstance] unretweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = NO;
                self.tweet = self.tweet;
            }
        }];
    } else {
        [[TwitterClient sharedInstance] retweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = YES;
                self.tweet = self.tweet;
            }
        }];
    }
}

- (IBAction)onTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        [[TwitterClient sharedInstance] unfavoriteTweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                self.tweet = tweet;
            }
        }];
    } else {
        [[TwitterClient sharedInstance] favoriteTweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                self.tweet = tweet;
            }
        }];
    }
}

@end
