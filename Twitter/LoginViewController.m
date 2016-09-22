//
//  LoginViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@implementation LoginViewController

- (void) viewDidLoad {
    [super viewDidLoad];
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
