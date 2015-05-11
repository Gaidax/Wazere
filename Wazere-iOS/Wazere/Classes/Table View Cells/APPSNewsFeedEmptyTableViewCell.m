//
//  APPSNewsFeedEmptyTableViewCell.m
//  Wazere
//
//  Created by Gaidax on 12/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNewsFeedEmptyTableViewCell.h"

@implementation APPSNewsFeedEmptyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)facebookButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(findFacebookFriendsToFollowAction)]) {
        [self.delegate findFacebookFriendsToFollowAction];
    }
}
@end
