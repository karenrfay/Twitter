//
//  MenuViewController.h
//  Twitter
//
//  Created by Karen Fay on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (nonatomic) BOOL isOpen;

- (void) openMenu;
- (void) closeMenu;

- (void) setContentViewController:(UIViewController *) contentViewController;

@end
