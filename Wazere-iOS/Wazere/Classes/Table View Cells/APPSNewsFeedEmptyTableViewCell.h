//
//  APPSNewsFeedEmptyTableViewCell.h
//  Wazere
//
//  Created by Gaidax on 12/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APPSNewsFeedEmptyTableViewCellDelegate <NSObject>
- (void)findFacebookFriendsToFollowAction;
@end

@interface APPSNewsFeedEmptyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookFriendsButton;

@property (weak, nonatomic) id<APPSNewsFeedEmptyTableViewCellDelegate> delegate;

@end
