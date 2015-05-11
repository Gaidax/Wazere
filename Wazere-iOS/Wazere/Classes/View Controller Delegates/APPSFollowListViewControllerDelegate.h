//
//  APPSUserListViewControllerDelegate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyTableViewDelegate.h"
#import "APPSStrategyTableViewDataSource.h"
#import "APPSSearchResultTableViewCell.h"
#import "APPSLoadingTableViewCell.h"

@class APPSRACBaseRequest, APPSPaginationModel;

@interface APPSFollowListViewControllerDelegate
    : NSObject<APPSStrategyTableViewDataSource, APPSStrategyTableViewDelegate,
               APPSSearchResultTableViewCellDelegate>
@property(strong, nonatomic) NSString *filter;
@property(strong, nonatomic) NSString *usersListKeyPath;
@property(strong, nonatomic) NSMutableArray *usersModels;
@property(assign, nonatomic) APPSLoadingResultState currentResultState;
@property(assign, nonatomic) BOOL reloadingOnlyRows;
@property(strong, nonatomic) APPSPaginationModel *paginationModel;
@property(weak, nonatomic) APPSRACBaseRequest *userListRequest;

- (NSMutableDictionary *)requestParams;
- (void)reloadUsersList;
- (void)clearLoadedData;
- (void)loadNextPage;
- (void)processUserListResponse:(NSDictionary *)response;
- (void)openProfileScreenForUser:(APPSSomeUser *)user;
- (BOOL)isRightViewSelectedForUser:(APPSSomeUser *)user;
- (APPSSomeUser *)userForReusableView:(UIView *)view;
- (APPSSearchResultRightViewMode)cellRightViewMode;

- (NSString *)noResultsCellTitle;
@end
