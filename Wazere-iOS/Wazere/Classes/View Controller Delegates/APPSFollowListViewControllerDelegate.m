//
//  APPSUserListViewControllerDelegate.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFollowListViewControllerDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSRACBaseRequest.h"
#import "APPSSomeUser.h"
#import "APPSFollowUtility.h"
#import "APPSPaginationModel.h"

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileSegueState.h"

@implementation APPSFollowListViewControllerDelegate
@synthesize parentController = _parentController;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdateUserNotification:)
                                                 name:kUpdateUserNotificationName
                                               object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return [self.usersListKeyPath hasSuffix:@"following"] ? @"Followings list" : @"Followers list";
}

- (NSMutableArray *)usersModels {
  if (!_usersModels) {
    _usersModels = [[NSMutableArray alloc] init];
  }
  return _usersModels;
}

- (void)clearLoadedData {
  NSInteger previousRowsCount = [self sharePhotoRowsCount];

  self.paginationModel = nil;
  self.usersModels = nil;

  if (self.reloadingOnlyRows) {
    [self reloadTableViewRowsWithPreviousRowsCount:previousRowsCount];
  }
}

#pragma mark Notifications

- (void)handleUpdateUserNotification:(NSNotificationCenter *)notification {
  if (self.parentController.view.window) {
    [self.parentController.tableView reloadData];
  }
}

#pragma mark - APPSStrategyTableViewDataSource

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController {
  self.parentController = parentController;

  if (self.parentController.refreshControl.isRefreshing) {
    [self clearLoadedData];
  }

  [self reloadUsersList];
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.usersModels.count) {
    tableView.separatorColor = [UIColor colorWithWhite:1.000 alpha:0.700];
    APPSSearchResultTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:kFollowListTableViewCell
                                        forIndexPath:indexPath];
    APPSSomeUser *user = (self.usersModels)[indexPath.row];
    cell.rightViewSelected = [self isRightViewSelectedForUser:user];
    cell.userModel = user;
    cell.delegate = self;
    cell.rightViewMode = [self cellRightViewMode];
    return cell;
  } else {
    tableView.separatorColor = [UIColor clearColor];
    APPSLoadingTableViewCell *loadingCell =
        [tableView dequeueReusableCellWithIdentifier:kFollowListLoadingCellIdentifier
                                        forIndexPath:indexPath];

    switch (self.currentResultState) {
      case APPSLoadingResultStateError:
        [loadingCell.activityIndicator stopAnimating];
        loadingCell.errorLabel.text = NSLocalizedString(@"Error loading", nil);
        break;
      case APPSLoadingResultStateNoResults:
        [loadingCell.activityIndicator stopAnimating];
        loadingCell.errorLabel.text = [self noResultsCellTitle];
        break;
      case APPSLoadingResultStateLoading:
        [loadingCell.activityIndicator startAnimating];
        loadingCell.errorLabel.text = @"";
        break;
      case APPSLoadingResultStateNormal:
        [loadingCell.activityIndicator stopAnimating];
        loadingCell.errorLabel.text = @"";
        break;
    }
    return loadingCell;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.usersModels.count ? self.usersModels.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kFollowListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  [self openProfileScreenForUser:(self.usersModels)[indexPath.row]];
}

- (void)openProfileScreenForUser:(APPSSomeUser *)user {
  APPSProfileViewController *viewController = [self.parentController.storyboard
      instantiateViewControllerWithIdentifier:@"APPSProfileViewController"];
  APPSProfileViewControllerDelegate *viewControllerDelegate =
      [[APPSProfileViewControllerDelegate alloc] initWithViewController:viewController user:user];
  APPSProfileViewControllerConfigurator *viewControllerConfigurator =
      [[APPSProfileViewControllerConfigurator alloc] init];

  viewController.configurator = viewControllerConfigurator;
  viewController.delegate = viewControllerDelegate;
  viewController.dataSource = viewControllerDelegate;
  viewController.state = [[APPSProfileSegueState alloc] init];

  [self.parentController.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Cell Configuration Helpers

- (APPSSearchResultRightViewMode)cellRightViewMode {
  return APPSSearchResultRightViewModeFollow;
}

- (BOOL)isRightViewSelectedForUser:(APPSSomeUser *)user {
  return [user.isFollowed boolValue];
}

- (NSString *)noResultsCellTitle {
  return NSLocalizedString(@"No Results", nil);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat bottomEdge = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame);
  if (bottomEdge >= scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)) {
    [self loadNextPage];
  }
}

- (void)loadNextPage {
  if (self.paginationModel.currentPage < self.paginationModel.totalPages) {
    [self reloadUsersList];
  }
}

#pragma mark - APPSSearchResultTableViewCellDelegate

- (void)reusableView:(UIView *)view followAction:(UIButton *)sender {
  APPSSomeUser *user = [self userForReusableView:view];

  BOOL isFollowed = [user.isFollowed boolValue];

  if (isFollowed) {
    [[[APPSUtilityFactory sharedInstance] followUtility] unFollowUser:user
              withCompletionHandler:NULL
                       errorHandler:NULL];
  } else {
    [[[APPSUtilityFactory sharedInstance] followUtility] followUser:user
            withCompletionHandler:NULL
                     errorHandler:NULL];
  }
}

- (APPSSomeUser *)userForReusableView:(UIView *)view {
  return ((APPSSearchResultTableViewCell *)view).userModel;
}

#pragma mark - Users List Loading

- (void)reloadUsersList {
  [self.userListRequest cancel];
  APPSRACBaseRequest *userListRequest = [[APPSRACBaseRequest alloc] initWithObject:nil
                                                             params:[self requestParams]
                                                             method:HTTPMethodGET
                                                            keyPath:self.usersListKeyPath
                                                         disposable:nil];
  self.userListRequest = userListRequest;
  self.currentResultState = APPSLoadingResultStateLoading;
  @weakify(self);
  [self.userListRequest.execute subscribeNext:^(NSDictionary *response) {
      @strongify(self);
      [self processUserListResponse:response];
  } error:^(NSError *error) {
      @strongify(self);
    if (self.userListRequest == userListRequest) {
      self.currentResultState = APPSLoadingResultStateError;
      NSLog(@"%@", error);
      if (!self.reloadingOnlyRows) {
        [self.parentController.tableView reloadData];
      }
    }
  }];
}

- (void)processUserListResponse:(NSDictionary *)response {
  NSInteger rowsCount = [self sharePhotoRowsCount];

  [self fillUsersListWithResponse:response];

  if (self.reloadingOnlyRows) {
    [self reloadTableViewRowsWithPreviousRowsCount:rowsCount];
  } else {
    [self.parentController.tableView reloadData];
  }
}

- (void)reloadTableViewRowsWithPreviousRowsCount:(NSInteger)rowsCount {
  NSInteger nbRowToInsert = [self sharePhotoRowsCount];

  NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < nbRowToInsert; i++) {
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
  }

  NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < rowsCount; i++) {
    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
  }

  [self.parentController.tableView beginUpdates];
  [self.parentController.tableView deleteRowsAtIndexPaths:indexPathsToDelete
                                         withRowAnimation:UITableViewRowAnimationNone];
  [self.parentController.tableView insertRowsAtIndexPaths:indexPathsToInsert
                                         withRowAnimation:UITableViewRowAnimationNone];
  [self.parentController.tableView endUpdates];
}

- (NSInteger)sharePhotoRowsCount {
  return self.usersModels.count ? self.usersModels.count + 1 : 1;
}

- (NSMutableDictionary *)requestParams {
  if (self.usersModels.count != 0 && self.paginationModel.currentPage != 0) {
    return [@{ @"page" : @(self.paginationModel.currentPage + 1) } mutableCopy];
  }
  return nil;
}

- (void)fillUsersListWithResponse:(NSDictionary *)response {
  NSMutableArray *newUsersList = [[NSMutableArray alloc] init];
  NSError *error = nil;
  NSString *responseKey = kUsersInfoResponseKey;

  for (NSDictionary *user in response[responseKey]) {
    APPSSomeUser *someUser = [[APPSSomeUser alloc] initWithDictionary:user error:&error];
    if (someUser) {
      [newUsersList addObject:someUser];
    } else {
      NSLog(@"%@", error);
    }
  }

  self.paginationModel =
      [[APPSPaginationModel alloc] initWithDictionary:response[@"pagination"] error:&error];

  if (error) {
    NSLog(@"Error while parsing %@ %@", responseKey, error);
  }

  [self.usersModels addObjectsFromArray:newUsersList];
  if (!newUsersList.count) {
    self.currentResultState = APPSLoadingResultStateNoResults;
  } else {
    self.currentResultState = APPSLoadingResultStateNormal;
  }
}

@end
