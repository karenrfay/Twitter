//
//  TweetsViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "ProfileCell.h"
#import "TweetCell.h"
#import "TwitterClient.h"

@interface TweetsViewController() <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tweetsViewType == TweetsViewTypeHome || self.user == nil) {
        self.title = @"Home";
    } else if (self.user) {
        self.title = self.user.name;
    }

    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self loadTweets:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTweet:(Tweet *) tweet {
    if (self.tweetsViewType == TweetsViewTypeHome) {
        NSArray* tweets = [[NSArray alloc] initWithObjects:tweet, nil];
        self.tweets = [tweets arrayByAddingObjectsFromArray:self.tweets];
        [self.tableView reloadData];
    }
}

- (void)didLoadTweets:(NSArray *)tweets error:(NSError *)error {
    self.tweets = tweets;
    [self.tableView reloadData];

    [self.refreshControl endRefreshing];
}

- (void)loadTweets:(UIRefreshControl *)refreshControl {
    if (self.tweetsViewType == TweetsViewTypeHome) {
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            [self didLoadTweets:tweets error:error];
        }];
    } else if (self.tweetsViewType == TweetsViewTypeUser) {
        [[TwitterClient sharedInstance] userTimelineWithParams:nil user:self.user completion:^(NSArray *tweets, NSError *error) {
            if (tweets && tweets.count > 0) {
                Tweet * tweet = tweets[0];
                self.user = tweet.user;
            }
            [self didLoadTweets:tweets error:error];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.user) {
        return self.tweets.count + 1;
    } else {
        return self.tweets.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tweetIndex = indexPath.row;
    if (self.user && tweetIndex > 0) {
        tweetIndex--;
    }

    if (self.user && indexPath.row == 0) {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        [cell setUser:self.user];
        return cell;
    } else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        Tweet *tweet = [self.tweets objectAtIndex:tweetIndex];
        [cell setTweet:tweet];
        return cell;
    }
}

- (IBAction)onSignOut:(id)sender {
    [[TwitterClient sharedInstance] logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TweetCell* cell = (TweetCell*)sender;
    if ([segue.identifier isEqualToString:@"profileSegue"] || [segue.identifier isEqualToString:@"replySegue"]) {
        // TODO: fix me with a better pattern
        cell = (TweetCell* )[[sender superview] superview];
    }

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger tweetIndex = indexPath.row;
    if (self.user && tweetIndex > 0) {
        tweetIndex--;
    }

    Tweet *tweet = [self.tweets objectAtIndex:tweetIndex];
    if ([segue.identifier isEqualToString:@"tweetSegue"]) {
        TweetViewController *vc = segue.destinationViewController;
        vc.tweet = tweet;
    } else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        TweetsViewController *vc = segue.destinationViewController;
        vc.user = tweet.user;
        vc.tweetsViewType = TweetsViewTypeUser;
    } else if ([segue.identifier isEqualToString:@"composeSegue"]) {
        ComposeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"replySegue"]) {
        ComposeViewController *vc = segue.destinationViewController;
        vc.replyToTweet = tweet;
        vc.delegate = self;
    }
}

@end
