//
//  APPSNewsFeedViewControllerDelegate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPSFollowListViewControllerDelegate.h"
#import "APPSPaginationModel.h"
#import "APPSSegmentSuplementaryView.h"

@interface APPSNewsFeedViewControllerDelegate
    : APPSFollowListViewControllerDelegate<UICollectionViewDataSource, UICollectionViewDelegate>
- (void)reloadUsersListUsingFilter:(NSString *)filter;
@end
