//
//  LoginViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface LoginViewController()
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@end


@implementation LoginViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    User *user = [User currentUser];
    if (user) {
        self.loginLabel.text = @"Twitter";
        [self performSegueWithIdentifier:@"postLoginSegue" sender:self];
    } else {
        self.loginLabel.text = @"Login with Twitter";
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onTapLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"postLoginSegue" sender:self];
        } else {
            NSLog(@"Login error: %@", error);
        }
    }];
}

@end
