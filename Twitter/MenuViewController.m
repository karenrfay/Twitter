//
//  MenuViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "MenuViewController.h"
#import "TwitterMenuViewController.h"

@interface MenuViewController()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (strong, nonatomic) UIBarButtonItem *menuButton;

@end

const int kMenuWidth = 250;

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(openMenu)];
    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TwitterMenuViewController *twitterMenu = [storyboard instantiateViewControllerWithIdentifier:@"TwitterMenuViewController"];

    twitterMenu.menu = self;
    [self setMenuViewController:twitterMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openMenu {
    self.isOpen = YES;
    self.maskView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void) closeMenu {
    self.isOpen = NO;
    self.maskView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.leftMarginConstraint.constant = -kMenuWidth;
        [self.view layoutIfNeeded];
    }];
}

- (void) setMenuViewController:(UIViewController *) menuViewController {
    [self addChildViewController:menuViewController];
    menuViewController.view.frame = self.menuView.bounds;
    [self.menuView addSubview:menuViewController.view];
    [menuViewController didMoveToParentViewController:self];
}

- (void) setContentViewController:(UIViewController *) contentViewController {
    [self addChildViewController:contentViewController];
    contentViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:contentViewController.view];
    [contentViewController didMoveToParentViewController:self];

    UINavigationController *nav = (UINavigationController *)contentViewController;
    UIViewController *topViewController = [nav topViewController];
    topViewController.navigationItem.leftBarButtonItem = self.menuButton;
}

- (IBAction)onDragMenu:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        int left = self.isOpen ? 0 : -kMenuWidth;
        left += translation.x;
        if (left > 0) {
            left = 0;
        } else if (left < -kMenuWidth) {
            left = -kMenuWidth;
        }
        self.leftMarginConstraint.constant = left;
        self.maskView.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.isOpen && translation.x < 0) {
            [self closeMenu];
        } else if (!self.isOpen && translation.x > 0) {
            [self openMenu];
        }
    }
}

- (IBAction)onTapMask:(id)sender {
    [self closeMenu];
}

@end
