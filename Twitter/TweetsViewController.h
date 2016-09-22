//
//  TweetsViewController.h
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef enum {
    TweetsViewTypeHome,
    TweetsViewTypeMentions,
    TweetsViewTypeRetweets,
    TweetsViewTypeUser
} TweetsViewType;

@interface TweetsViewController : UIViewController

@property (nonatomic) TweetsViewType tweetsViewType;
@property (nonatomic, strong) User* user;

@end
