//
//  APPSSearchResultTableViewCell.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSFollowReusableViewDelegate.h"

@class APPSSomeUser;
@class APPSSearchResultTableViewCell;

typedef NS_ENUM(NSInteger, APPSSearchResultRightViewMode) {
  APPSSearchResultRightViewModeFollow,
  APPSSearchResultRightViewModeRadio
};

@protocol APPSSearchResultTableViewCellDelegate<APPSFollowReusableViewDelegate>
@optional
- (void)profileActionInCell:(APPSSearchResultTableViewCell *)cell;
@end

@interface APPSSearchResultTableViewCell : UITableViewCell

@property(assign, nonatomic) APPSSearchResultRightViewMode rightViewMode;
@property(strong, nonatomic) APPSSomeUser *userModel;
@property(assign, nonatomic) BOOL rightViewSelected;

@property(weak, nonatomic) id<APPSSearchResultTableViewCellDelegate> delegate;

- (void)setCollectionViewDataSourceDelegate:
            (id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
                                      index:(NSInteger)index;
@end
