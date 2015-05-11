//
//  APPSChooseAllTableHeaderView.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFollowReusableViewDelegate.h"

@class APPSSharePhotoTextField;

@interface APPSSearchTableHeaderView : UITableViewHeaderFooterView
@property(nonatomic, readonly, retain) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet APPSSharePhotoTextField *searchTextField;
@end
