//
//  MenuViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "MenuViewController.h"
#import "TweetsViewController.h"

@interface MenuViewController()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@end


@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    // Home timeline
    UINavigationController *homeTweetsNavController = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    //homeTweetsNavController.navigationBar.tintColor = [UIColor whiteColor];
    TweetsViewController *homeTweetsController = (TweetsViewController *)[homeTweetsNavController topViewController];
    homeTweetsController.tweetsViewType = TweetsViewTypeHome;
    //homeTweetsController.user = [User currentUser];
    [self setContentViewController:(UIViewController *)homeTweetsNavController];

    // Profile timeline
    /*UINavigationController *profileTweetsNavController = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    profileTweetsNavController.navigationBar.tintColor = [UIColor whiteColor];
    TweetsViewController *profileTweetsController = (TweetsViewController *)[profileTweetsNavController topViewController];
    profileTweetsController.tweetsViewType = TweetsViewTypeUser;
    User *user = [[User alloc] init];
    user.screenname = @"FallonTonight";
    profileTweetsController.user = user;
    [self setContentViewController:(UIViewController *)profileTweetsNavController];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openMenu {
    self.isOpen = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void) closeMenu {
    self.isOpen = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.leftMarginConstraint.constant = -200;
        [self.view layoutIfNeeded];
    }];
}

- (void) setContentViewController:(UIViewController *) contentViewController {
    [self addChildViewController:contentViewController];
    contentViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:contentViewController.view];
    [contentViewController didMoveToParentViewController:self];
}

- (IBAction)onDragMenu:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateChanged) {
        /*if (self.isOpen) {
            self.leftMarginConstraint.constant = translation.x < 0 ? 200+translation.x : 0;
        } else {
            self.leftMarginConstraint.constant = translation.x > 0 ? translation.x : 0;
        }*/
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.isOpen && translation.x < 0) {
            [self closeMenu];
        } else if (!self.isOpen && translation.x > 0) {
            [self openMenu];
        }
    }
}
@end
