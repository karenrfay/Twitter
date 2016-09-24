//
//  TweetViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/20/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetViewController()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Tweet";
    [self showTweet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTweet {
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
    self.tweetTextLabel.text = self.tweet.text;
    self.dateLabel.text = [self.tweet getRelativeTimestamp];
    self.retweetCountLabel.text = [Tweet getFormattedCount:self.tweet.retweetCount];
    self.favoriteCountLabel.text = [Tweet getFormattedCount:self.tweet.favoriteCount];

    if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }

    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweeted"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
}

- (IBAction)onTapReply:(id)sender {
    [self performSegueWithIdentifier:@"replySegue" sender:self];
}

- (IBAction)onTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [[TwitterClient sharedInstance] unretweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount = tweet.retweetCount;
                [self showTweet];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] retweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount = tweet.retweetCount;
                [self showTweet];
            }
        }];
    }
}

- (IBAction)onTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        [[TwitterClient sharedInstance] unfavoriteTweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount = tweet.favoriteCount;
                [self showTweet];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] favoriteTweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount = tweet.favoriteCount;
                [self showTweet];
            }
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"replySegue"]) {
        ComposeViewController *vc = segue.destinationViewController;
        vc.replyToTweet = self.tweet;
    }
}


@end
