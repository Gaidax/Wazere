//
//  APPSFacebookSearchDelegate.m
//  Wazere
//
//  Created by Gaidax on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFacebookSearchDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSRACBaseRequest.h"
#import "APPSSearchConstants.h"
#import "APPSFeedableModel.h"
#import "APPSSomeUser.h"
#import "APPSFacebookSearchResult.h"
#import "APPSFollowAllHeaderView.h"
#import "APPSFollowUtility.h"
#import "APPSPhotoImageView.h"
#import "APPSImageCollectionViewCell.h"

@interface APPSFacebookSearchDelegate ()
@property(strong, nonatomic) NSArray *facebookPhotos;
@end

@implementation APPSFacebookSearchDelegate

- (void)reloadUsersList {
  [self loadFacebookFriendsList];
}

- (NSString *)screenName {
  return @"Find facebook friends to follow";
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  if (self.usersModels.count) {
    [(APPSSearchResultTableViewCell *)cell setCollectionViewDataSourceDelegate:self
                                                                         index:indexPath.row];
  }
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  APPSFollowAllHeaderView *followView =
      [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFacebookSearchTableViewHeader];
  NSString *postFix = self.usersModels.count == 1 ? @"" : @"s";
  followView.friendsCountLabel.text =
      [NSString stringWithFormat:NSLocalizedString(@"%lu Friend%@ on Wazere", nil),
                                 (unsigned long)self.usersModels.count, postFix];
  followView.delegate = self;
  return self.usersModels.count ? followView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.usersModels.count) {
    NSArray *photos = (self.facebookPhotos)[indexPath.row];
    return photos.count ? PhotoSearchCellHeight : SearchCellHeight;
  } else {
    return CGRectGetHeight(tableView.frame) - 2 * SegmentHeaderViewHeight;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return self.usersModels.count ? SearchCellHeight : 0.1f;
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  APPSImageCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:kFacebookSearchCollectionViewCell
                                                forIndexPath:indexPath];

  NSArray *photos = [self.facebookPhotos objectAtIndex:collectionView.tag];
  APPSFeedableModel *photo = [photos objectAtIndex:indexPath.row];
  [cell.imageView setShouldBlur:!photo.isAllowed];
  cell.imageView.notAvailableLabel.text = photo.tagline;

  [cell.imageView.activityIndicator startAnimating];
  [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photo.photoUrl]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                       NSURL *imageURL) {
                               if (!error) {
                                 [cell.imageView.activityIndicator stopAnimating];
                               }
                           }];

  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  NSArray *photos = [self.facebookPhotos objectAtIndex:collectionView.tag];
  return photos.count;
}

#pragma mark - Data Processing

- (void)loadFacebookFriendsList {
  FBSession *session = [FBSession activeSession];
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];

  if (session.isOpen) {
    self.currentResultState = APPSLoadingResultStateLoading;
    FBAccessTokenData *token = session.accessTokenData;

    NSDictionary *params = @{ @"fb_token" : token.accessToken };
    [self.userListRequest cancel];
    APPSRACBaseRequest *facebookFriendsRequest = [[APPSRACBaseRequest alloc]
        initWithObject:nil
                params:params
                method:HTTPMethodGET
               keyPath:[NSString stringWithFormat:kFacebookFrindsKeyPath, currentUser.userId]
            disposable:nil];
    self.userListRequest = facebookFriendsRequest;

    @weakify(self);
    [facebookFriendsRequest.execute subscribeNext:^(NSDictionary *response) {
        @strongify(self);
        [self proccesFriendListWithResponse:response];
        [self.parentController.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
      if (self.userListRequest == facebookFriendsRequest) {
        NSLog(@"%@", error);
        self.currentResultState = APPSLoadingResultStateError;
        [self.parentController.tableView reloadData];
      }
    }];
  } else {
    @weakify(self);
    [[[APPSUtilityFactory sharedInstance] facebookUtility]
        openSessionWithHandler:^(NSString *token, NSError *error) {
            @strongify(self);
            if (token) {
              [self reloadUsersList];
            } else {
              self.currentResultState = APPSLoadingResultStateError;
              [self.parentController.tableView reloadData];
            }
        }];
  }
}

- (void)proccesFriendListWithResponse:(NSDictionary *)response {
  NSMutableArray *friends = [[NSMutableArray alloc] init];
  NSMutableArray *photos = [[NSMutableArray alloc] init];
  NSError *error = nil;
  for (NSDictionary *friend in response[@"users"]) {
    APPSFacebookSearchResult *facebookFriend =
        [[APPSFacebookSearchResult alloc] initWithDictionary:friend error:&error];
    if (facebookFriend != nil) {
      APPSSomeUser *user = [[APPSSomeUser alloc] init];
      user.avatar = facebookFriend.avatarUrl;
      user.userId = facebookFriend.userId;
      user.isFollowed = [NSNumber numberWithBool:NO];
      user.username = facebookFriend.username;

      [friends addObject:user];
      [photos addObject:facebookFriend.photos];
    } else {
      NSLog(@"%@", error);
    }
  }
  self.usersModels = [friends copy];
  self.facebookPhotos = [photos copy];
  self.currentResultState =
      friends.count ? APPSLoadingResultStateNormal : APPSLoadingResultStateNoResults;
}

#pragma mark - APPSFollowTableViewCellDelegate

- (void)reusableView:(UIView *)view followAction:(UIButton *)sender {
  if ([view isMemberOfClass:[APPSSearchResultTableViewCell class]]) {
    [super reusableView:view followAction:sender];
  } else {
    NSMutableArray *friendsIdsToFollow = [[NSMutableArray alloc] init];

    for (APPSFacebookSearchResult *searchResult in self.usersModels) {
      [friendsIdsToFollow addObject:searchResult.userId];
    }

    @weakify(self);
    [[[APPSUtilityFactory sharedInstance] followUtility] followUsers:friendsIdsToFollow
        withCompletionHandler:^(NSDictionary *response) {
            @strongify(self) NSLog(@"%@", response[@"message"]);
            [self loadFacebookFriendsList];
        }
        errorHandler:^(NSError *error) { NSLog(@"%@", error); }];
  }
}

- (void)profileActionInCell:(APPSSearchResultTableViewCell *)cell {
  [self openProfileScreenForUser:cell.userModel];
}

@end
