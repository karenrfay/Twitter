//
//  TwitterMenuViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/23/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TwitterMenuViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface TwitterMenuViewController ()

@property (nonatomic, strong) UINavigationController *homeNavView;
@property (nonatomic, strong) UINavigationController *profileNavView;
@property (nonatomic, strong) UINavigationController *mentionsNavView;

@end

@implementation TwitterMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    // Home timeline
    self.homeNavView = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    TweetsViewController *homeTweetsController = (TweetsViewController *)[self.homeNavView topViewController];
    homeTweetsController.tweetsViewType = TweetsViewTypeHome;
    [self.menu setContentViewController:self.homeNavView];

    // Profile timeline
    self.profileNavView = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    TweetsViewController *profileTweetsController = (TweetsViewController *)[self.profileNavView topViewController];
    profileTweetsController.tweetsViewType = TweetsViewTypeUser;
    profileTweetsController.user = [User currentUser];

    // Mentions timeline
    self.mentionsNavView = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    TweetsViewController *mentionsTweetsController = (TweetsViewController *)[self.mentionsNavView topViewController];
    mentionsTweetsController.tweetsViewType = TweetsViewTypeMentions;
    mentionsTweetsController.user = [User currentUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapHome:(id)sender {
    [self.menu setContentViewController:self.homeNavView];
    [self.menu closeMenu];
}

- (IBAction)onTapProfile:(id)sender {
    [self.menu setContentViewController:self.profileNavView];
    [self.menu closeMenu];
}

- (IBAction)onTapMentions:(id)sender {
    [self.menu setContentViewController:self.mentionsNavView];
    [self.menu closeMenu];
}

- (IBAction)onSignOut:(id)sender {
    [[TwitterClient sharedInstance] logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
