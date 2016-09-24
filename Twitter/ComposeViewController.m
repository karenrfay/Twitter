//
//  ComposeViewController.m
//  Twitter
//
//  Created by Karen Fay on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "Tweet.h"
#import "TwitterClient.h"

@interface ComposeViewController() <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

const int kMaxTweetLength = 140;

@implementation ComposeViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tweetField becomeFirstResponder];
    self.tweetField.delegate = self;

    if (self.replyToTweet) {
        self.tweetField.text = [NSString stringWithFormat:@"@%@ ", self.replyToTweet.user.screenname];
    }

    self.tweetButton.layer.cornerRadius = 5.0;
    self.tweetButton.layer.masksToBounds = YES;

    [self updateCharCount];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)keyboardDidShow:(NSNotification *)sender {
    CGRect frame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect newFrame = [self.view convertRect:frame fromView:[[UIApplication sharedApplication] delegate].window];
    self.bottomConstraint.constant = -(newFrame.origin.y - CGRectGetHeight(self.view.frame));
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.bottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

- (IBAction)onCancelTweet:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateCharCount];
}

- (IBAction)onTweetButton:(id)sender {
    int tweetLength = (int)self.tweetField.text.length;
    int remaining = kMaxTweetLength - tweetLength;

    if (tweetLength > 0 && remaining >= 0) {
        Tweet *tweet = [[Tweet alloc] init];
        tweet.text = self.tweetField.text;
        if (self.replyToTweet) {
            tweet.replyToTweet = self.replyToTweet;
        }
        [[TwitterClient sharedInstance] sendTweetWithParams:nil tweet:tweet completion:^(Tweet *tweet, NSError *error) {
            if (self.delegate) {
                [self.delegate didTweet:tweet];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)updateCharCount {
    int remaining = kMaxTweetLength - (int)self.tweetField.text.length;

    self.charCountLabel.text = [NSString stringWithFormat:@"%d", remaining];

    if (remaining <= 0) {
        self.charCountLabel.textColor = [UIColor redColor];
        self.tweetButton.enabled = NO;
    } else {
        self.charCountLabel.textColor = [UIColor lightGrayColor];
        self.tweetButton.enabled = YES;
    }
}

@end
