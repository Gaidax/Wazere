//
//  APPSNewsFeedViewControllerDelegate.m
//  Wazere
//
//  Created by Gaidax on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNewsFeedViewControllerDelegate.h"
#import "APPSStrategyTableViewController.h"

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSShowProfilePhotoConfigurator.h"
#import "APPSShowProfilePhotoDelegate.h"

#import "APPSNewsFeedConstants.h"

#import "APPSNewsFeedTableViewCell.h"
#import "APPSImageCollectionViewCell.h"

#import "APPSNewsFeedCommand.h"

#import "APPSPhotoModel.h"
#import "APPSPhotoImageView.h"

#import "APPSNewsFeedEmptyTableViewCell.h"

@interface APPSNewsFeedViewControllerDelegate () <APPSNewsFeedTableViewCellDelegate,
                                                  APPSNewsFeedEmptyTableViewCellDelegate>
@property(strong, nonatomic) APPSPaginationModel *paginationModel;
@property(strong, nonatomic) NSString *filter;
@property(strong, nonatomic) APPSNewsFeedCommand *newsFeedCommand;
@end

@implementation APPSNewsFeedViewControllerDelegate
@synthesize parentController = _parentController;

static NSString *const followingFilter = @"followed";
static NSString *const yoursFilter = @"mine";

- (NSString *)screenName {
  return @"News feed";
}

- (void)reloadUsersList {
  [self loadCurrentUserNewsFeed];

  APPSNotificationUtility *utility = [APPSUtilityFactory sharedInstance].notificationUtility;

  UIViewController *notificationController = [utility viewControllerForLastNotification];
  if (notificationController) {
    [self.parentController.navigationController pushViewController:notificationController
                                                          animated:NO];
  }
}

- (void)reloadUsersListUsingFilter:(NSString *)filter {
  self.filter = filter;
  [self clearLoadedData];
  [self reloadUsersList];
}

#pragma mark - Data Loading

- (void)loadCurrentUserNewsFeed {
  [self.parentController.tableView reloadData];
  self.currentResultState = APPSLoadingResultStateLoading;

  self.filter = self.filter ? self.filter : yoursFilter;
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
    @"type" : self.filter
  }];

  if (self.usersModels.count != 0 && self.paginationModel.currentPage != 0) {
    [params setValue:@(self.paginationModel.currentPage + 1) forKey:@"page"];
  }

  APPSCurrentUser *user = [[APPSCurrentUserManager sharedInstance] currentUser];
  [self.newsFeedCommand cancel];
  self.newsFeedCommand = [[APPSNewsFeedCommand alloc]
      initWithObject:nil
              params:[params copy]
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:KeyPathUserFeed, user.userId]
          disposable:nil];
  @weakify(self);
  [self.newsFeedCommand.execute subscribeNext:^(NSDictionary *dict) {
      @strongify(self);
      self.paginationModel =
          [[APPSPaginationModel alloc] initWithDictionary:dict[@"pagination"] error:nil];

      if ([self.filter isEqualToString:followingFilter]) {
        [self updateFollowedFeedsModelDataWithFeeds:dict[@"response"]];
        [self.parentController.tableView reloadData];
      } else {
        [self updateYoursNewsFeedWithDictionary:dict];
        [self.parentController.tableView reloadData];
      }

  } error:^(NSError *error) {
      if (error.code == HTTPStausCodeCanceled) {
        self.currentResultState = APPSLoadingResultStateLoading;
      } else {
        self.currentResultState = APPSLoadingResultStateError;
      }
      [self.parentController.tableView reloadData];
      NSLog(@"%@", error);
  }];
}

#pragma mark - Following Feeds

- (void)updateFollowedFeedsModelDataWithFeeds:(NSArray *)feeds {
  BOOL needToLoadNextPage = self.paginationModel.currentPage < self.paginationModel.totalPages;
  NSMutableArray *newFeeds = [NSMutableArray new];
  for (NSDictionary *feed in feeds) {
    APPSUserFeedsModel *userFeeds = [[APPSUserFeedsModel alloc] initWithDictionary:feed error:nil];

    for (NSInteger i = APPSNewsFeedTypeLike; i < APPSNewsFeedTypeFollowRequest + 1; i++) {
      NSPredicate *filteringPredicate = [NSPredicate predicateWithFormat:@"feedType == %ld", i];
      NSArray *newUserFeeds = [userFeeds.feeds filteredArrayUsingPredicate:filteringPredicate];

      if (newUserFeeds.count) {
        [newFeeds addObjectsFromArray:
                      [self packedUserFeeds:newUserFeeds byType:(APPSNewsFeedType)i intoFeed:feed]];
      }
      if ((self.usersModels.count + newFeeds.count) % 10 == 0) {
        needToLoadNextPage = NO;
      }
    }
  }
  if (!newFeeds.count) {
    self.currentResultState = APPSLoadingResultStateNoResults;
  } else {
    self.currentResultState = APPSLoadingResultStateNormal;
  }
  [self.usersModels addObjectsFromArray:newFeeds];
  if (needToLoadNextPage) {
    [self loadNextPage];
  }
}

- (NSArray *)packedUserFeeds:(NSArray *)newUserFeeds
                      byType:(APPSNewsFeedType)newsFeedType
                    intoFeed:(NSDictionary *)feed {
  NSMutableArray *newFeeds = [[NSMutableArray alloc] init];
  NSError *error = nil;

  // comment feeds should be separated one by one, other can be packed together
  if (newsFeedType == APPSNewsFeedTypeComment) {
    for (APPSNewsFeedModel *comment in newUserFeeds) {
      APPSUserFeedsModel *commentUserFeed =
          [[APPSUserFeedsModel alloc] initWithDictionary:feed error:&error];
      commentUserFeed.feeds = @[ comment ];
      commentUserFeed.feedType = @(newsFeedType);
      [newFeeds addObject:commentUserFeed];
    }
  } else {
    APPSUserFeedsModel *typeUserFeed =
        [[APPSUserFeedsModel alloc] initWithDictionary:feed error:&error];
    typeUserFeed.feeds = newUserFeeds;
    typeUserFeed.feedType = @(newsFeedType);
    [newFeeds addObject:typeUserFeed];
  }

  return [newFeeds copy];
}

#pragma mark - Yours Feed

- (void)updateYoursNewsFeedWithDictionary:(NSDictionary *)dictionary {
  NSError *error = nil;
  self.paginationModel =
      [[APPSPaginationModel alloc] initWithDictionary:dictionary[@"pagination"] error:&error];

  NSMutableArray *newFeeds = [[NSMutableArray alloc] init];
  for (NSDictionary *feed in dictionary[@"feeds"]) {
    APPSNewsFeedModel *newsFeed = [[APPSNewsFeedModel alloc] initWithDictionary:feed error:&error];
    APPSUserFeedsModel *userFeeds = [[APPSUserFeedsModel alloc] init];
    userFeeds.user = [[APPSSomeUser alloc] initWithDictionary:feed[@"user"] error:&error];
    userFeeds.feeds = @[ newsFeed ];
    userFeeds.feedType = @(newsFeed.feedType);
    [newFeeds addObject:userFeeds];
  }
  [self.usersModels addObjectsFromArray:newFeeds];
  if (!self.usersModels.count) {
    self.currentResultState = APPSLoadingResultStateNoResults;
  } else {
    self.currentResultState = APPSLoadingResultStateNormal;
  }
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.usersModels.count) {
    tableView.separatorColor = [UIColor colorWithWhite:1.000 alpha:0.700];
    APPSNewsFeedTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:kFeedTableViewCell];
    cell.cellType = (APPSNewsFeedTableViewCellType)[self.filter isEqualToString : yoursFilter];
    cell.feedModel = self.usersModels[indexPath.row];
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
    cell.delegate = self;
    return cell;
  } else {
    if (self.currentResultState == APPSLoadingResultStateNoResults) {
      return [self emptyTableViewCell];
    } else {
      return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.usersModels.count) {
    APPSUserFeedsModel *newsFeedModel = self.usersModels[indexPath.row];
    return [APPSNewsFeedTableViewCell
        feedCellHeightForModel:newsFeedModel
                        ofType:(APPSNewsFeedTableViewCellType)[self.filter
                                                                   isEqualToString : yoursFilter]];
  } else {
    if (self.currentResultState == APPSLoadingResultStateNoResults) {
      return [self emptyTableViewCellHeight];
    } else {
      return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (collectionView.tag < self.usersModels.count) {
    APPSUserFeedsModel *feedModel = self.usersModels[collectionView.tag];
    return [feedModel shouldShowImages] ? feedModel.feeds.count : 0;
  }
  return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  APPSImageCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:kFeedCollectionViewCell
                                                forIndexPath:indexPath];
  APPSUserFeedsModel *userFeedModel = self.usersModels[collectionView.tag];
  APPSNewsFeedModel *newsModel = userFeedModel.feeds[indexPath.row];
  APPSFeedableModel *feedableModel = newsModel.feedable;

  [cell.imageView setShouldBlur:!feedableModel.isAllowed];
  cell.imageView.notAvailableLabel.text = feedableModel.tagline;

  [cell.imageView.activityIndicator startAnimating];
  [cell.imageView sd_setImageWithURL:[NSURL URLWithString:feedableModel.photoUrl]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                       NSURL *imageURL) {
                               if (!error) {
                                 [cell.imageView.activityIndicator stopAnimating];
                               }
                           }];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [self showPhoto:indexPath.row forCell:collectionView.tag];
}

- (void)showPhoto:(NSInteger)photoIndex forCell:(NSInteger)cellIndex {
  APPSUserFeedsModel *userFeedModel = self.usersModels[cellIndex];
  APPSNewsFeedModel *newsModel = userFeedModel.feeds[photoIndex];
  APPSFeedableModel *feedableModel = newsModel.feedable;

  APPSPhotoModel *photo = [[APPSPhotoModel alloc] init];
  photo.photoId = feedableModel.feedableId;

  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  APPSProfileViewController *selectedPhotoController = (APPSProfileViewController *)
      [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  selectedPhotoController.configurator = [[APPSShowProfilePhotoConfigurator alloc] init];
  APPSShowProfilePhotoDelegate *delegate =
      [[APPSShowProfilePhotoDelegate alloc] initWithViewController:selectedPhotoController
                                                              user:photo.user
                                                     selectedPhoto:photo];
  selectedPhotoController.delegate = delegate;
  selectedPhotoController.dataSource = delegate;
  [self.parentController.navigationController pushViewController:selectedPhotoController
                                                        animated:YES];
}

#pragma mark - APPSNewsFeedTableViewCellDelegate

- (void)selectWord:(NSString *)word inNewsFeedCell:(APPSNewsFeedTableViewCell *)cell {
  APPSUserFeedsModel *userFeedsModel = cell.feedModel;
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];

  for (APPSNewsFeedModel *newsFeed in userFeedsModel.feeds) {
    APPSSomeUser *someUser = nil;

    if (([newsFeed.recipient.username isEqualToString:word] &&
         ![newsFeed.recipient.userId isEqualToNumber:currentUser.userId])) {
      someUser = newsFeed.recipient;
    } else if ([userFeedsModel.user.username isEqualToString:word]) {
      someUser = userFeedsModel.user;
    }

    if (someUser) {
      [self openProfileScreenForUser:someUser];
      break;
    }
  }
}

- (void)commentedImageActionInCell:(APPSNewsFeedTableViewCell *)cell {
  [self showPhoto:0 forCell:cell.collectionView.tag];
}

- (void)profileActionInCell:(APPSNewsFeedTableViewCell *)cell {
  [self openProfileScreenForUser:cell.feedModel.user];
}

#pragma mark - Follow user methods

- (APPSSomeUser *)userForReusableView:(UIView *)view {
  APPSUserFeedsModel *feedModel = ((APPSNewsFeedTableViewCell *)view).feedModel;
  return feedModel.user;
}

#pragma mark - Empty screen Helpers

- (void)findFacebookFriendsToFollowAction {
  [self.parentController performSegueWithIdentifier:kNewsFeedFacebookFriendsSegue
                                             sender:self.parentController];
}

- (APPSNewsFeedEmptyTableViewCell *)emptyTableViewCell {
  APPSNewsFeedEmptyTableViewCell *cell =
      [self.parentController.tableView dequeueReusableCellWithIdentifier:kFeedEmptyCell];

  cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self emptyTableViewCellHeight]);

  cell.messageLabel.text = [self emptyMessage];
  cell.titleLabel.text = [self emptyTitle];
  cell.delegate = self;

  cell.facebookFriendsButton.hidden = [self.filter isEqualToString:yoursFilter];
  return cell;
}

- (NSString *)emptyMessage {
  return
      [self.filter isEqualToString:yoursFilter]
          ? NSLocalizedString(@"When someone you follow comments on or likes one of your photos, "
                              @"you'll see it here",
                              nil)
          : NSLocalizedString(
                @"When someone you follow comments on or likes a photo, you'll see it here", nil);
}

- (NSString *)emptyTitle {
  return [self.filter isEqualToString:yoursFilter]
             ? NSLocalizedString(@"Recent activity on your photos", nil)
             : NSLocalizedString(@"Activity from people you follow", nil);
}

- (CGFloat)emptyTableViewCellHeight {
  return CGRectGetHeight(self.parentController.tableView.frame) - FeedReusableHeaderViewHeight;
}

@end
