//
//  ProfileCell.m
//  Twitter
//
//  Created by Karen Fay on 9/20/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileBannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;

@end

@implementation ProfileCell


- (void)setUser:(User *)user {
    _user = user;

    self.descLabel.text = user.summary;
    self.userNameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
    self.followersCount.text = [self formatCount:(long)user.followersCount];
    self.followingCount.text = [self formatCount:(long)user.followingCount];
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.profileImage.layer.cornerRadius = 5.0;
    self.profileImage.layer.masksToBounds = YES;
    [self.profileBannerImage setImageWithURL:[NSURL URLWithString:user.profileBannerUrl]];
    self.profileBannerImage.backgroundColor = user.profileLinkColor;
}

- (NSString *)formatCount:(long)count {
    NSString *str;
    if (count >= 1000000) {
        str = [NSString stringWithFormat:@"%0.2fM", count / 1000000.0];
    } else if (count >= 1000) {
        str = [NSString stringWithFormat:@"%ldK", lroundf(count / 1000.0)];
    } else {
        str = [NSString stringWithFormat:@"%ld", count];
    }
    return str;
}

@end
