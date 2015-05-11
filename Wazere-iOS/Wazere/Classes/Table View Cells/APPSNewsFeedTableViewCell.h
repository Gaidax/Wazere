//
//  APPSNewsFeedTableViewCell.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSUserFeedsModel.h"
#import "APPSFollowReusableViewDelegate.h"

typedef NS_ENUM(NSInteger, APPSNewsFeedTableViewCellType) {
  APPSNewsFeedTableViewCellTypeFollowed,
  APPSNewsFeedTableViewCellTypeYours
};

@class APPSNewsFeedTableViewCell;

@protocol APPSNewsFeedTableViewCellDelegate<APPSFollowReusableViewDelegate>
- (void)selectWord:(NSString *)word inNewsFeedCell:(APPSNewsFeedTableViewCell *)cell;
- (void)commentedImageActionInCell:(APPSNewsFeedTableViewCell *)cell;
- (void)profileActionInCell:(APPSNewsFeedTableViewCell *)cell;
@end

@interface APPSNewsFeedTableViewCell : UITableViewCell

@property(weak, nonatomic) id<APPSNewsFeedTableViewCellDelegate> delegate;
@property(assign, nonatomic) APPSNewsFeedTableViewCellType cellType;
@property(strong, nonatomic) APPSUserFeedsModel *feedModel;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (CGFloat)feedCellHeightForModel:(APPSUserFeedsModel *)model
                           ofType:(APPSNewsFeedTableViewCellType)cellType;
- (void)setCollectionViewDataSourceDelegate:
            (id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
                                      index:(NSInteger)index;
@end