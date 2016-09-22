//
//  ComposeViewController.h
//  Twitter
//
//  Created by Karen Fay on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


@protocol ComposeViewControllerDelegate <NSObject>

- (void)didTweet:(Tweet *)tweet;

@end


@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *replyToTweet;

@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;

@end
