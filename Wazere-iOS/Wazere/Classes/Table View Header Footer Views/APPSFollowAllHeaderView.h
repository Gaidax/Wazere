//
//  APPSFollowAllHeaderView.h
//  Wazere
//
//  Created by Gaidax on 10/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSFollowReusableViewDelegate.h"

@interface APPSFollowAllHeaderView : UITableViewHeaderFooterView

@property(nonatomic, readonly, retain) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property(weak, nonatomic) id<APPSFollowReusableViewDelegate> delegate;

@end
