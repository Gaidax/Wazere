//
//  APPSProfileViewControllerDelegate.m
//  Wazere
//
//  Created by Bogdan Bilonog on 10/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileViewControllerDelegate.h"

#import "APPSGridLayout.h"
#import "NSDate+APPSRelativeDate.h"
#import "NSNumber+APPSRealiveNumber.h"
#import "APPSHomeDelegate.h"

#import "APPSStrategyTableViewController.h"
#import "APPSProfileCollectionReusableView.h"
#import "APPSProfileRectCollectionViewCell.h"
#import "APPSGridCell.h"
#import "APPSLoadingCollectionViewCell.h"

#import "APPSProfileCommand.h"

#import "APPSPaginationModel.h"
#import "APPSPhotoModel.h"

#import "APPSCommentViewController.h"
#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileSegueState.h"

#import "APPSLikedPhotosConfigurator.h"
#import "APPSLikedPhotosDelegate.h"

#import "APPSShowProfilePhotoConfigurator.h"
#import "APPSShowProfilePhotoDelegate.h"

#import "APPSFollowListViewControllerConfigurator.h"
#import "APPSFollowListViewControllerDelegate.h"

#import "APPSResizableLabel.h"
#import "APPSPhotoImageView.h"
#import "APPSTabBarViewController.h"

#import "APPSMapViewController.h"
#import "APPSMapDelegate.h"
#import "APPSPhotoRequest.h"

#import "APPSOwnProfileRightButtonStrategy.h"
#import "APPSOtherProfileRightButtonStrategy.h"

@interface APPSProfileViewControllerDelegate () <APPSProfileRectCollectionViewCellDelegate,
                                                 APPSProfileCollectionReusableViewDelegate,
                                                 UIActionSheetDelegate>

@property(assign, readonly, getter=isCurrentUser) BOOL isCurrentUser;
@property(assign, nonatomic) BOOL shouldSaveCurrentScrollPosition;
@property(strong, nonatomic) APPSSpinnerView *spinnerView;

@end

@implementation APPSProfileViewControllerDelegate

@synthesize viewModel = _viewModel;
@synthesize parentController = _parentController;

- (instancetype)initWithViewController:(APPSProfileViewController *)viewController
                                  user:(id<APPSUserProtocol>)user {
  self = [super init];
  if (self) {
    self.parentController = viewController;

    self.user = user;
    self.photoModels = [NSMutableArray array];

    self.viewMode = CollectionViewModeUndefined;
    self.selectedTab = APPSProfileSelectedTabTypeGrid;

    [self initCollectionViewLayouts];
    [self setupNotifications];
    self.rightNavigationButtonStrategy =
        [self isCurrentUser] ? [[APPSOwnProfileRightButtonStrategy alloc] initWithDelegate:self]
                             : [[APPSOtherProfileRightButtonStrategy alloc] initWithDelegate:self];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self initWithViewController:nil user:nil];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Profile screen";
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_performingPhotoRequest cancel];
  [_performingUserRequest cancel];
}

#pragma mark - Reloading

- (void)forceCollectionViewReload:(NSNotification *)notification {
  self.photoModelsStatusType = PhotoModelsStatusTypeIndefinitely;
  [self reloadIfOnScreen];
}

- (void)handleDeletePhotoNotification:(NSNotification *)notification {
  APPSPhotoModel *deletedPhoto =
      (APPSPhotoModel *)notification.userInfo[kDeleteProfilePhotoNotificationKey];
  if (notification.object != self) {
    [self deletePhotoFromPhotoModels:deletedPhoto];
  }
}

- (void)handleUpdatePhotoNotification:(NSNotification *)notification {
  APPSPhotoModel *photo = (APPSPhotoModel *)[notification userInfo][kUpdatePhotoNotificationKey];
  for (APPSPhotoModel *currentPhoto in self.photoModels) {
    if (photo.photoId == currentPhoto.photoId) {
      currentPhoto.commentsCount = photo.commentsCount;
      currentPhoto.comments = photo.comments;
      currentPhoto.watchedCount = photo.watchedCount;
      currentPhoto.likesCount = photo.likesCount;
      currentPhoto.isAllowed = photo.isAllowed;
      currentPhoto.likedByMe = photo.likedByMe;
      [self reloadIfOnScreen];
      break;
    }
  }
}

- (void)handleUpdateUserNotification:(NSNotification *)notification {
  APPSSomeUser *user = (APPSSomeUser *)notification.userInfo[kUpdateUserNotificationKey];
  if (self.photoModelsStatusType != PhotoModelsStatusTypeIndefinitely) {
    APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
    if ([self isCurrentUser]) {
      self.user.followingCount = currentUser.followingCount;
    } else {
      if (self.user && [self.user.userId compare:user.userId] == NSOrderedSame) {
        self.user.followersCount = user.followersCount;
        ((APPSSomeUser *)self.user).isFollowed = user.isFollowed;
      }
    }
    for (APPSPhotoModel *currentPhoto in self.photoModels) {
      if ([currentPhoto.user.userId compare:currentUser.userId] == NSOrderedSame) {
        currentPhoto.user.followingCount = currentUser.followingCount;
      } else if ([currentPhoto.user.userId compare:user.userId] == NSOrderedSame) {
        currentPhoto.user.followersCount = user.followersCount;
        currentPhoto.user.isFollowed = user.isFollowed;
      }
    }
  }
  [self reloadIfOnScreen];
}

- (void)loadData {
  [self loadProfile];
  [self loadPhotos];
}

- (void)resetProperties {
  self.paginationModel = [[APPSPaginationModel alloc] init];
  self.photoModelsStatusType = PhotoModelsStatusTypeIndefinitely;
  self.viewMode = CollectionViewModeUndefined;
  self.photoModels = [NSMutableArray array];
  [self changeCollectionViewLayoutWithViewMode:self.viewMode];
}

- (BOOL)isCurrentUser {
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
  return self.user ? [currentUser.userId isEqualToNumber:self.user.userId] : NO;
}

#pragma mark - initCollectionViewLayouts

- (void)initCollectionViewLayouts {
  self.rectCollectionViewLayout = [[APPSProfileRectCollectionViewLayout alloc] init];
  self.rectCollectionViewLayout.delegate = self;
  self.squareCollectionViewLayout = [[APPSGridLayout alloc] init];
  self.baseLayout = [[APPSProfileCollectionViewLayout alloc] init];
}

- (void)setupNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(forceCollectionViewReload:)
                                               name:kReloadProfileNotificationName
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleDeletePhotoNotification:)
                                               name:kDeleteProfilePhotoNotificationName
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleUpdatePhotoNotification:)
                                               name:kUpdatePhotoNotificationName
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleUpdateUserNotification:)
                                               name:kUpdateUserNotificationName
                                             object:nil];
}

#pragma mark - loadPhotos

- (NSMutableDictionary *)addPaginationPageAtParams:(NSMutableDictionary *)params {
  if (self.photoModels.count != 0 && self.paginationModel.currentPage != 0) {
    params = [@{ @"page" : @(self.paginationModel.currentPage + 1) } mutableCopy];
  }
  return params;
}

- (NSMutableDictionary *)addOtherParamsAtParams:(NSMutableDictionary *)params {
  return params;
}

- (APPSRACBaseRequest *)photoRequestWithParams:(NSDictionary *)params {
  APPSRACBaseRequest *photoRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              params:params
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:KeyPathUserPhotos, self.user.userId]
          disposable:nil];
  return photoRequest;
}

- (APPSRACBaseRequest *)photoRequest {
  NSMutableDictionary *params = [self addPaginationPageAtParams:nil];
  params = [self addOtherParamsAtParams:params];
  // MAKE PHOTO REQUEST
  return [self photoRequestWithParams:[params copy]];
}

- (void)createPhotoModelsWithResponseObjects:(id)response {
  NSError *error = nil;
  self.paginationModel =
      [[APPSPaginationModel alloc] initWithDictionary:response[@"pagination"] error:&error];
  [self.photoModels
      addObjectsFromArray:[APPSPhotoModel arrayOfModelsFromDictionaries:response[@"photos"]
                                                                  error:&error]];
  self.shouldSaveCurrentScrollPosition = YES;
  self.photoModelsStatusType =
      self.photoModels.count == 0 ? PhotoModelsStatusTypeEmpty : PhotoModelsStatusTypeNormal;
}

- (void)checkUserDataAndReloadData {
  [self reloadIfOnScreen];
}

- (void)executePhotoRequest:(APPSRACBaseRequest *)photoRequest {
  @weakify(self);
  [photoRequest.execute subscribeNext:^(NSDictionary *response) {
    @strongify(self);
    [self createPhotoModelsWithResponseObjects:response];
    [self checkUserDataAndReloadData];
    self.performingPhotoRequest = nil;
  } error:^(NSError *error) {
    @strongify(self);
    NSLog(@"%@\nERROR! Can't load images", error);
    if (photoRequest == self.performingPhotoRequest) {
      self.photoModelsStatusType = PhotoModelsStatusTypeError;
      [self reloadIfOnScreen];
      self.performingPhotoRequest = nil;
    }
  }];
}

- (void)loadPhotos {
  [self.performingPhotoRequest cancel];
  APPSRACBaseRequest *photoRequest = [self photoRequest];
  [self executePhotoRequest:photoRequest];
  self.performingPhotoRequest = photoRequest;
}

- (NSMutableArray *)cellExtraHeights {
  NSMutableArray *cellExtraHeights = [NSMutableArray array];
  for (APPSPhotoModel *photoModel in self.photoModels) {
    CGRect commentRect =
        [self rectFormString:[self photoCommentsAttributedStringWithPhoto:photoModel]
                    maxWidth:CGRectGetWidth(self.parentController.collectionView.bounds) -
                             kProfileCommentsLabelLeadingOffset
                   maxHeight:CGFLOAT_MAX
                      offset:kResizableLabelDefaultOffset];
    CGRect descriptionRect = [self
        rectFormString:[self photoDescriptionAttributedStringWithText:photoModel.photoDescription]
              maxWidth:kDescriptionLabelWidthKoef *
                       CGRectGetWidth(self.parentController.collectionView.bounds)
             maxHeight:CGFLOAT_MAX
                offset:kResizableLabelDefaultOffset];
    [cellExtraHeights addObject:@(CGRectGetHeight(commentRect) + CGRectGetHeight(descriptionRect))];
  }

  return cellExtraHeights;
}

#pragma mark - loadProfile

- (void)loadProfile {
  [self.performingUserRequest cancel];
  APPSProfileCommand *profileRequest = [[APPSProfileCommand alloc]
      initWithObject:nil
              method:HTTPMethodGET
             keyPath:[KeyPathUser stringByAppendingFormat:@"/%@", self.user.userId]
          disposable:nil];
  @weakify(self);
  [profileRequest.execute subscribeNext:^(id<APPSUserProtocol> user) {
    @strongify(self);
    NSString *navigationItemTitle = nil;

    self.user = user;
    navigationItemTitle = [self.user.username uppercaseString];

    self.parentController.navigationItem.title = navigationItemTitle;

    self.shouldSaveCurrentScrollPosition = YES;

    switch (self.photoModelsStatusType) {
      case PhotoModelsStatusTypeError:
      case PhotoModelsStatusTypeIndefinitely:
        break;
      case PhotoModelsStatusTypeEmpty:
      case PhotoModelsStatusTypeNormal:
        [self reloadIfOnScreen];
        break;
    }
    self.performingUserRequest = nil;
  } error:^(NSError *error) {
    @strongify(self);
      NSLog(@"%@\nERROR! Can't load profile", error);
      if (profileRequest == self.performingUserRequest) {
        self.performingUserRequest = nil;
      }
  }];
  self.performingUserRequest = profileRequest;
}

#pragma mark - UICollectionViewDataSource

- (void)reloadIfOnScreen {
  if (self.parentController.view.window) {
    [self.parentController reloadCollectionView];
  } else {
    if (self.photoModelsStatusType == PhotoModelsStatusTypeIndefinitely) {
      [self.performingPhotoRequest cancel];
      [self.performingUserRequest cancel];
      [self resetProperties];
    }
  }
}

- (void)reloadCollectionViewController:
        (APPSStrategyCollectionViewController *__weak)parentController {
  if (parentController.refreshControl.isRefreshing) {
    self.photoModelsStatusType = PhotoModelsStatusTypeIndefinitely;
  }
  switch (self.photoModelsStatusType) {
    case PhotoModelsStatusTypeEmpty:
    case PhotoModelsStatusTypeError:
      self.photoModels = [NSMutableArray array];
      [self changeCollectionViewLayoutWithViewMode:CollectionViewModeUndefined];
      break;

    case PhotoModelsStatusTypeNormal:
      if (self.viewMode == CollectionViewModeUndefined) {
        self.viewMode = self.selectedTab == APPSProfileSelectedTabTypeList
                            ? CollectionViewModeRect
                            : CollectionViewModeSquare;
      }
      self.shouldSaveCurrentScrollPosition = YES;
      [self changeCollectionViewLayoutWithViewMode:self.viewMode];
      break;

    case PhotoModelsStatusTypeIndefinitely:
      [self resetProperties];
      [self loadData];
      break;
  }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.photoModels.count != 0 ? self.photoModels.count : 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  APPSProfileCollectionReusableView *view =
      [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                         withReuseIdentifier:kCollectionReusableView
                                                forIndexPath:indexPath];

  if (self.photoModelsStatusType != PhotoModelsStatusTypeIndefinitely) {
    view.profileButton.enabled = YES;
    view.profileButton.hidden = NO;
    view.followersLabel.userInteractionEnabled = view.followingLabel.userInteractionEnabled =
        view.followerCountLabel.userInteractionEnabled =
            view.followingCountLabel.userInteractionEnabled = YES;
    view.delegate = self;
    view.nameLabel.text = self.user.username;
    if (self.user.photosCount) {
      view.photoCountLabel.text = [NSString stringWithFormat:@"%@", self.user.photosCount];
      view.followerCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followersCount];
      view.followingCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followingCount];
    }
    view.likesCountLabel.text = [self.user.likesCount suffixNumber];
    view.viewsCountLabel.text = [self.user.viewsCount suffixNumber];
    view.bottomViewContainer.segmentControl.selectedSegmentIndex =
        self.viewMode == CollectionViewModeRect;

    if (self.isCurrentUser) {
      [view.profileButton setTitle:@"Edit your profile" forState:UIControlStateNormal];
    } else {
      BOOL isFollowed = ((APPSSomeUser *)self.user).isFollowed.boolValue;
      [view.profileButton setTitle:(isFollowed ? NSLocalizedString(@"Unfollow", nil)
                                               : NSLocalizedString(@"Follow", nil))
                          forState:UIControlStateNormal];
    }
    if (!self.isCurrentUser && ((APPSSomeUser *)self.user).banned.boolValue) {
      view.photoImageView.image = [[[APPSUtilityFactory sharedInstance] imageUtility]
          imageNamed:@"blocked_user_placeholder"];
      view.photoCountLabel.text = view.followingCountLabel.text = @"0";
    } else {
      view.personalDataLabel.text = self.user.userDescription;
      [view.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar]
                             placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")];
    }
  }
  return view;
}

- (void)configureCellImageView:(APPSPhotoImageView *)imageView
                withPhotoModel:(APPSPhotoModel *)photoModel {
  [self blurImageViewIfNeeded:imageView withPhotoModel:photoModel];

  [imageView.activityIndicator startAnimating];
  [imageView sd_setImageWithURL:self.viewMode == CollectionViewModeRect ? photoModel.middleURL
                                                                        : photoModel.thumbnailURL
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                  NSURL *imageURL) {
                        if (image) {
                          [imageView.activityIndicator stopAnimating];
                        } else {
                          NSLog(@"%@", error);
                        }
                      }];
}

- (void)blurImageViewIfNeeded:(APPSPhotoImageView *)imageView
               withPhotoModel:(APPSPhotoModel *)photoModel {
  BOOL shouldBlur = !photoModel.isAllowed;
  [imageView setShouldBlur:shouldBlur];
  imageView.notAvailableLabel.text = photoModel.tagLine;
}

- (void)configureButtonsOnCell:(APPSProfileRectCollectionViewCell *)cell
                withPhotoModel:(APPSPhotoModel *)photoModel {
  cell.likeButton.selected = photoModel.likedByMe;
  cell.likeButton.enabled = cell.commentButton.enabled = cell.watchedCountButton.enabled =
      cell.moreOptionsButton.enabled = photoModel.isAllowed;
  cell.likesCountLabel.text =
      [NSString stringWithFormat:@"%lu", (unsigned long)photoModel.likesCount];
  [cell.commentButton
      setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)photoModel.commentsCount]
      forState:UIControlStateNormal];
  [cell.watchedCountButton
      setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)photoModel.watchedCount]
      forState:UIControlStateNormal];

  UIColor *disabledTextColor = UIColorFromRGB(185, 185, 185, 1.0);
  UIColor *enabledTextColor = UIColorFromRGB(37, 37, 37, 1.0);
  cell.likesCountLabel.textColor = photoModel.isAllowed ? enabledTextColor : disabledTextColor;
  [cell.likeButton setTitleColor:disabledTextColor forState:UIControlStateDisabled];
  [cell.likeButton setTitleColor:disabledTextColor
                        forState:UIControlStateSelected | UIControlStateDisabled];
  [cell.commentButton setTitleColor:disabledTextColor forState:UIControlStateDisabled];
  [cell.watchedCountButton setTitleColor:disabledTextColor forState:UIControlStateDisabled];
}

- (void)configureRectCell:(APPSProfileRectCollectionViewCell *)cell
                withModel:(APPSPhotoModel *)photoModel {
  cell.delegate = self;

  cell.topUserNameLabel.text = photoModel.user.username;

  [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.user.avatar]
                        placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")];

  [self configureCellImageView:cell.imageView withPhotoModel:photoModel];
  cell.timePassedLabel.text = [NSDate relativeDateFromString:photoModel.createdAt];

  cell.commentsLabel.attributedText = [self photoCommentsAttributedStringWithPhoto:photoModel];

  [self configureButtonsOnCell:cell withPhotoModel:photoModel];

  NSDictionary *stringAttributes = @{NSFontAttributeName : FONT_HELVETICANEUE(14.f)};
  if (photoModel.photoDescription) {
    cell.descriptionLabel.attributedText =
        [self photoDescriptionAttributedStringWithText:photoModel.photoDescription];
  }
  cell.locationLabel.attributedText = [[NSAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"%@", photoModel.location]
          attributes:stringAttributes];
  cell.locationIcon.hidden = !photoModel.location.length;
}

- (void)configureLoadingCell:(APPSLoadingCollectionViewCell *)cell {
  switch (self.photoModelsStatusType) {
    case PhotoModelsStatusTypeIndefinitely:
      [cell.activityIndicatorView startAnimating];
      [self setTabbarCameraButtonHighlighted:NO];
      cell.errorLabel.hidden = YES;
      cell.emptyView.hidden = YES;
      break;

    case PhotoModelsStatusTypeEmpty:
      [cell.activityIndicatorView stopAnimating];
      if ([self shouldShowEmptyScreen]) {
        cell.errorLabel.hidden = YES;
        cell.emptyView.hidden = NO;
        cell.emptyView.messageLabel.text = [self emptyMessage];
        cell.emptyView.titleLabel.text = [self emptyTitle];
        cell.emptyView.topImageViewHidden = ![self shouldShowTopImage];
        cell.emptyView.bottomImageView.hidden = ![self shouldShowBottomImage];
        if ([self shouldHighlightTabbarCameraButton]) {
          [self setTabbarCameraButtonHighlighted:YES];
        }
      } else {
        cell.emptyView.hidden = YES;
        cell.errorLabel.hidden = NO;
        cell.errorLabel.text = !self.isCurrentUser && ((APPSSomeUser *)self.user).banned.boolValue
                                   ? NSLocalizedString(@"This profile has been blocked", nil)
                                   : NSLocalizedString(@"No photos", nil);
      }
      break;

    case PhotoModelsStatusTypeError:
      [self setTabbarCameraButtonHighlighted:NO];
      [cell.activityIndicatorView stopAnimating];
      cell.errorLabel.text = NSLocalizedString(@"Error loading", nil);
      cell.errorLabel.hidden = NO;
      cell.emptyView.hidden = YES;
      break;

    default:
      break;
  }
}

- (BOOL)shouldHighlightTabbarCameraButton {
  return YES;
}

- (BOOL)shouldShowEmptyScreen {
  UINavigationController *navigation = self.parentController.navigationController;
  return self.photoModelsStatusType == PhotoModelsStatusTypeEmpty &&
         [navigation isEqual:[[APPSTabBarViewController rootViewController] viewControllers]
                                 [profileIndex]] &&
         [[navigation.viewControllers firstObject] isEqual:self.parentController] &&
         [self isCurrentUser];
}

- (NSString *)emptyMessage {
  return NSLocalizedString(@"Tap on the camera to share your first photo", nil);
}

- (NSString *)emptyTitle {
  return NSLocalizedString(@"Photos you share will show up here", nil);
}

- (BOOL)shouldShowTopImage {
  return NO;
}

- (BOOL)shouldShowBottomImage {
  return YES;
}

- (void)setTabbarCameraButtonHighlighted:(BOOL)highlighted {
  APPSTabBarViewController *tabbarVC = [APPSTabBarViewController rootViewController];
  UIView *view = [tabbarVC.tabBar viewWithTag:cameraIndex];

  if (!view && highlighted) {
    UIColor *bgColor = [UIColor colorWithWhite:0.933 alpha:1.000];

    CGFloat itemWidth = CGRectGetWidth(tabbarVC.tabBar.frame) / tabbarVC.tabBar.items.count;
    UIView *bgView =
        [[UIView alloc] initWithFrame:CGRectMake(itemWidth * cameraIndex, 0, itemWidth,
                                                 CGRectGetHeight(tabbarVC.tabBar.frame))];
    bgView.tag = cameraIndex;
    bgView.backgroundColor = bgColor;
    [tabbarVC.tabBar insertSubview:bgView atIndex:1];
  } else if (!highlighted) {
    [view removeFromSuperview];
  }
}

- (void)configureGridCell:(APPSGridCell *)cell withPhotoModel:(APPSPhotoModel *)photo {
  [self configureCellImageView:cell.gridImage withPhotoModel:photo];
  [cell.userImage sd_setImageWithURL:[NSURL URLWithString:photo.user.avatar]
                    placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")];
  cell.usernameLabel.text = [NSString stringWithFormat:@"%@", photo.user.username];
  [cell.viewsButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)photo.watchedCount]
                    forState:UIControlStateNormal];
  [cell.likesButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)photo.likesCount]
                    forState:UIControlStateNormal];
  [cell.commentsButton
      setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)photo.commentsCount]
      forState:UIControlStateNormal];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.photoModelsStatusType == PhotoModelsStatusTypeIndefinitely ||
      self.photoModelsStatusType == PhotoModelsStatusTypeEmpty ||
      self.photoModelsStatusType == PhotoModelsStatusTypeError) {
    APPSLoadingCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:kLoadingCollectionViewCell
                                                  forIndexPath:indexPath];
    [self configureLoadingCell:cell];
    return cell;
  } else {
    if ([self.parentController.collectionView.collectionViewLayout
            isKindOfClass:[APPSProfileRectCollectionViewLayout class]]) {
      APPSProfileRectCollectionViewCell *cell =
          [collectionView dequeueReusableCellWithReuseIdentifier:kRectCollectionViewCell
                                                    forIndexPath:indexPath];
      APPSPhotoModel *photoModel = self.photoModels[indexPath.row];
      [self configureRectCell:cell withModel:photoModel];

      return cell;
    } else {
      APPSGridCell *cell =
          [collectionView dequeueReusableCellWithReuseIdentifier:kGridCollectionViewCell
                                                    forIndexPath:indexPath];
      APPSPhotoModel *photoModel = self.photoModels[indexPath.row];
      [self configureGridCell:cell withPhotoModel:photoModel];
      return cell;
    }
  }
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewMode == CollectionViewModeSquare) {
    if (indexPath.item >= self.photoModels.count) {
      NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                       code:4
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"Index is out of bounds"
                                   }]);
      return;
    }
    APPSPhotoModel *photo = (APPSPhotoModel *)self.photoModels[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    APPSProfileViewController *selectedPhotoController = (APPSProfileViewController *)
        [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
    selectedPhotoController.configurator = [[APPSShowProfilePhotoConfigurator alloc] init];
    APPSShowProfilePhotoDelegate *delegate =
        [[APPSShowProfilePhotoDelegate alloc] initWithViewController:selectedPhotoController
                                                                user:photo.user
                                                       selectedPhoto:photo];
    selectedPhotoController.delegate = delegate;
    selectedPhotoController.dataSource = delegate;
    self.shouldSaveCurrentScrollPosition = YES;
    [self.parentController.navigationController pushViewController:selectedPhotoController
                                                          animated:YES];
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat bottomEdge = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame);
  BOOL isNotLoadPhotos =
      !self.performingPhotoRequest.dataTask ||
      (self.performingPhotoRequest.dataTask.state != NSURLSessionTaskStateRunning &&
       self.performingPhotoRequest.dataTask.state != NSURLSessionTaskStateSuspended);
  if (isNotLoadPhotos &&
      bottomEdge >= scrollView.contentSize.height - CGRectGetHeight(scrollView.frame) &&
      self.paginationModel.currentPage != self.paginationModel.totalPages) {
    [self loadPhotos];
  }
}

#pragma mark - APPSProfileCollectionReusableViewDelegate

- (void)collectionReusableView:(UICollectionReusableView *)view gridAction:(UIButton *)sender {
  if (self.viewMode == CollectionViewModeRect) {
    self.selectedTab = APPSProfileSelectedTabTypeGrid;
    [self changeCollectionViewLayoutWithViewMode:CollectionViewModeSquare];
    [self.parentController.collectionView setContentOffset:CGPointZero];
  }
}

- (void)collectionReusableView:(UICollectionReusableView *)view listAction:(UIButton *)sender {
  if (self.viewMode == CollectionViewModeSquare) {
    self.selectedTab = APPSProfileSelectedTabTypeList;
    [self changeCollectionViewLayoutWithViewMode:CollectionViewModeRect];
    [self.parentController.collectionView setContentOffset:CGPointZero];
  }
}

- (void)reusableViewFollowersAction:(APPSProfileCollectionReusableView *)reusableView {
  [self loadUsersListControllerWithTitle:NSLocalizedString(@"Followers", nil)
                                 keyPath:KeyPathFollowersList];
}

- (void)reusableViewFollowingAction:(APPSProfileCollectionReusableView *)reusableView {
  [self loadUsersListControllerWithTitle:NSLocalizedString(@"Following", nil)
                                 keyPath:KeyPathFollowingList];
}

- (void)loadUsersListControllerWithTitle:(NSString *)title keyPath:(NSString *)keyPath {
  APPSStrategyTableViewController *followListController =
      [self.parentController.navigationController.storyboard
          instantiateViewControllerWithIdentifier:@"StrategyTableViewController"];
  followListController.title = title;
  followListController.configurator = [[APPSFollowListViewControllerConfigurator alloc] init];
  APPSFollowListViewControllerDelegate *followListDelegate =
      [[APPSFollowListViewControllerDelegate alloc] init];

  followListDelegate.usersListKeyPath = [NSString stringWithFormat:keyPath, self.user.userId];
  followListController.delegate = followListDelegate;
  followListController.dataSource = followListDelegate;

  [self.parentController.navigationController pushViewController:followListController animated:YES];
  [self setTabbarCameraButtonHighlighted:NO];
}

- (UICollectionViewLayout *)layoutForMode:(CollectionViewMode)mode {
  switch (mode) {
    case CollectionViewModeUndefined:
      self.viewMode = CollectionViewModeUndefined;
      return self.baseLayout;

    case CollectionViewModeRect:
      self.viewMode = CollectionViewModeRect;
      return self.rectCollectionViewLayout;

    case CollectionViewModeSquare:
      self.viewMode = CollectionViewModeSquare;
      return self.squareCollectionViewLayout;
  }
}

- (void)changeCollectionViewLayoutWithViewMode:(CollectionViewMode)viewMode {
  self.parentController.collectionView.dataSource = nil;
  [self.parentController.collectionView setCollectionViewLayout:[self layoutForMode:viewMode]
                                                       animated:NO];
  self.parentController.collectionView.dataSource = self.parentController;
  [self.parentController.collectionView reloadData];
  //  [self.parentController.collectionView layoutIfNeeded];

  if (!self.shouldSaveCurrentScrollPosition) {
    [self.parentController.collectionView setContentOffset:CGPointZero];
  } else {
    self.shouldSaveCurrentScrollPosition = NO;
  }
}

- (void)reusableView:(APPSProfileCollectionReusableView *)reusableView
       profileAction:(UIButton *)button {
  if (self.isCurrentUser) {
    [self.parentController performSegueWithIdentifier:kEditMyProfileSegue
                                               sender:self.parentController];
  } else {
    APPSSomeUser *user = (APPSSomeUser *)self.user;
    if (!user) {
      NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                       code:7
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"User is nil"
                                   }]);
      return;
    }

    NSString *method = nil;
    if ([user.isFollowed boolValue]) {
      method = HTTPMethodDELETE;
    } else {
      method = HTTPMethodPOST;
    }
    [self performProfileRequestMethod:method reusableView:reusableView sender:button];
  }
}

- (void)reusableView:(APPSProfileCollectionReusableView *)reusableView
          likeAction:(UIButton *)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
  APPSProfileViewController *likedPhototsController =
      [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  likedPhototsController.configurator = [[APPSLikedPhotosConfigurator alloc] init];
  APPSLikedPhotosDelegate *delegate =
      [[APPSLikedPhotosDelegate alloc] initWithViewController:likedPhototsController
                                                         user:self.user];
  likedPhototsController.delegate = delegate;
  likedPhototsController.dataSource = delegate;

  self.shouldSaveCurrentScrollPosition = YES;
  [self.parentController.navigationController pushViewController:likedPhototsController
                                                        animated:YES];
}

- (void)performProfileRequestMethod:(NSString *)method
                       reusableView:(APPSProfileCollectionReusableView *)reusableView
                             sender:(UIButton *)sender {
  APPSSomeUser *user = (APPSSomeUser *)self.user;

  if (self.user.userId == nil) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                     code:6
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"User is missing"
                                 }]);
    return;
  }
  [[[APPSUtilityFactory sharedInstance] followUtility] startFollowRequestWithUser:user method:method completionHandler:NULL errorHandler:NULL];
}

#pragma mark - APPSProfileRectCollectionViewCellDelegate

- (void)commentCell:(APPSProfileRectCollectionViewCell *)cell
     detectsHotWord:(HotWordType)hotWord
           withText:(NSString *)text {
  if (hotWord == HotWordTypeUsername) {
    NSIndexPath *indexPath = [self.parentController.collectionView indexPathForCell:cell];
    if (indexPath == nil) {
      return;
    }
    APPSPhotoModel *photo = (APPSPhotoModel *)self.photoModels[indexPath.row];
    id<APPSUserProtocol> user = [self searchUserInComments:photo.comments withName:text];
    if (user == nil) {
      NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                       code:5
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"Comment user not found"
                                   }]);
      return;
    }
    [[[APPSUtilityFactory sharedInstance] hotWordsUtility]
         openProfileWithUser:user
        navigationController:self.parentController.navigationController];
  } else {
    [[[APPSUtilityFactory sharedInstance] hotWordsUtility]
             detectedHotWord:hotWord
                    withText:text
        navigationController:self.parentController.navigationController];
  }
}

- (void)cellCommentsPhoto:(APPSProfileRectCollectionViewCell *)cell {
  NSIndexPath *cellIndexPath = [self.parentController.collectionView indexPathForCell:cell];
  if (cellIndexPath == nil) {
    return;
  }
  if (cellIndexPath.item >= self.photoModels.count) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                     code:3
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Index is out of bounds"
                                 }]);
    return;
  }
  APPSPhotoModel *photoModel = self.photoModels[cellIndexPath.item];
  if (!photoModel.isAllowed) {
    return;
  }
  APPSCommentViewController *viewController =
      [[APPSCommentViewController alloc] initWithPhotoModel:photoModel];
  viewController.hidesBottomBarWhenPushed = YES;
  self.shouldSaveCurrentScrollPosition = YES;
  [self.parentController.navigationController pushViewController:viewController animated:YES];
  //    [self performSegueWithIdentifier:@"CommentSegue" sender:self];
}

- (void)cellTapsMoreOptions:(APPSProfileRectCollectionViewCell *)cell {
  NSIndexPath *indexPath = [self.parentController.collectionView indexPathForCell:cell];
  if (indexPath == nil) {
    return;
  }
  if (indexPath.item >= self.photoModels.count) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                     code:2
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Index is out of bounds"
                                 }]);
    return;
  }
  self.selectedPhoto = (APPSPhotoModel *)self.photoModels[indexPath.row];
  UIActionSheet *moreOptionsAtionSheet = [self moreOptionsActionSheet];
  [moreOptionsAtionSheet showInView:self.parentController.collectionView];
}

- (void)cellLikeUnlikeAction:(APPSProfileRectCollectionViewCell *)cell
          withImageAnimation:(BOOL)imageAnimation {
  APPSPhotoModel *photoModel = [self photoModelForCell:cell];
  if (photoModel == nil || photoModel.isAllowed == NO) {
    return;
  } else {
    if (imageAnimation) {
      [self animateLikeImage];
    }
    UIButton *sender = cell.likeButton;
    [self sendLikeRequestForPhoto:photoModel like:!sender.selected];
  }
}

- (void)animateLikeImage {
  UIImageView *likeView = ((APPSProfileViewController *)self.parentController).likeImageView;

  [UIView animateWithDuration:0.8f
                   animations:^{
                     likeView.alpha = 1.f;
                     likeView.alpha = 0.f;
                   }];
}

- (void)sendLikeRequestForPhoto:(APPSPhotoModel *)photoModel like:(BOOL)like {
  NSString *method = @"";
  NSString *keyPath =
      [NSString stringWithFormat:KeyPathPhotoLikes, (unsigned long)photoModel.photoId];

  if (!like) {
    method = HTTPMethodDELETE;
  } else {
    method = HTTPMethodPOST;
  }

  APPSPhotoRequest *request =
      [[APPSPhotoRequest alloc] initWithObject:nil method:method keyPath:keyPath disposable:nil];

  [request.execute subscribeNext:^(APPSPhotoModel *photoModel) {

    if (photoModel == nil) {
      return;
    }
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kUpdatePhotoNotificationName
                      object:self
                    userInfo:@{kUpdatePhotoNotificationKey : photoModel}];
  } error:^(NSError *error) {
    NSLog(@"%@\nERROR! Can't like or unlike photo", error);
  }];
}

- (void)cellPhotoViewsAction:(APPSProfileRectCollectionViewCell *)cell {
  APPSPhotoModel *photoModel = [self photoModelForCell:cell];
  if (photoModel == nil || photoModel.isAllowed == NO) {
    return;
  } else {
    [self loadUsersListControllerWithTitle:NSLocalizedString(@"Views", nil)
                                   keyPath:[NSString
                                               stringWithFormat:KeyPathViewedUsersList,
                                                                (unsigned long)photoModel.photoId]];
  }
}

- (void)cellPhotoLikesAction:(APPSProfileRectCollectionViewCell *)cell {
  APPSPhotoModel *photoModel = [self photoModelForCell:cell];
  if (photoModel == nil || photoModel.isAllowed == NO) {
    return;
  } else {
    [self loadUsersListControllerWithTitle:NSLocalizedString(@"Likes", nil)
                                   keyPath:[NSString
                                               stringWithFormat:KeyPathLikedUsersList,
                                                                (unsigned long)photoModel.photoId]];
  }
}

- (void)profileActionInCell:(APPSProfileRectCollectionViewCell *)cell {
  NSInteger index = [self.parentController.collectionView indexPathForCell:cell].row;
  if (index >= self.photoModels.count) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                     code:1
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Index is out of bounds"
                                 }]);
    return;
  }
  APPSPhotoModel *photoModel = self.photoModels[index];
  if ([self openProfileForPhoto:photoModel]) {
    APPSSomeUser *user = photoModel.user;

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

    self.shouldSaveCurrentScrollPosition = YES;
    [self.parentController.navigationController pushViewController:viewController animated:YES];
  }
}

- (BOOL)openProfileForPhoto:(APPSPhotoModel *)photo {
  return !self.isCurrentUser;
}

- (id<APPSUserProtocol>)searchUserInComments:(NSArray *)comments withName:(NSString *)username {
  id<APPSUserProtocol> user;
  for (APPSCommentModel *comment in comments) {
    if ([username isEqualToString:comment.user.username]) {
      if ([comment.user.userId
              compare:[[[APPSCurrentUserManager sharedInstance] currentUser] userId]] ==
          NSOrderedSame) {
        user = [[APPSCurrentUserManager sharedInstance] currentUser];
      } else {
        user = comment.user;
      }
      break;
    }
  }
  return user;
}

- (void)locationSelectedInCell:(APPSProfileRectCollectionViewCell *)cell {
  NSIndexPath *indexPath = [self.parentController.collectionView indexPathForCell:cell];
  if (indexPath == nil) {
    return;
  }
  NSInteger index = indexPath.row;
  APPSPhotoModel *photoModel = (self.photoModels)[index];
  if (!photoModel.photoLatitude || !photoModel.photoLongitude) {
    return;
  }
  [[APPSTabBarViewController rootViewController]
      setPreviousTabIndex:[[APPSTabBarViewController rootViewController] selectedIndex]];
  UIViewController *viewController =
      [[APPSTabBarViewController rootViewController] viewControllers][mapIndex];
  [[APPSTabBarViewController rootViewController] setSelectedViewController:viewController];
  APPSMapViewController *mapController =
      (APPSMapViewController *)[[[[APPSTabBarViewController rootViewController] viewControllers]
              [mapIndex] viewControllers] firstObject];
  [(APPSMapDelegate *)mapController.delegate
      setSelectedPhotoCoordinate:CLLocationCoordinate2DMake([photoModel.photoLatitude floatValue],
                                                            [photoModel.photoLongitude  floatValue])];
}

#pragma mark UIActionSheet

- (NSString *)firstMoreOptionsButtonTitle {
  if ([self.selectedPhoto.user.userId unsignedIntegerValue] ==
      [[[[APPSCurrentUserManager sharedInstance] currentUser] userId] unsignedIntegerValue]) {
    return NSLocalizedString(@"Delete", nil);
  } else {
    return NSLocalizedString(@"Mark Inappropriate", nil);
  }
}

- (NSString *)secondMoreOptionsButtonTitle {
  return NSLocalizedString(@"Share to Twitter", nil);
}

- (NSString *)thirdMoreOptionsButtonTitle {
  return NSLocalizedString(@"Share To Facebook", nil);
}

- (UIActionSheet *)moreOptionsActionSheet {
  UIActionSheet *moreOptions =
      [[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:nil
                    destructiveButtonTitle:nil
                         otherButtonTitles:[self firstMoreOptionsButtonTitle], nil];
  BOOL showShareButtons = self.selectedPhoto.isPublic || [self isCurrentUser];
  if (showShareButtons) {
    [moreOptions addButtonWithTitle:[self secondMoreOptionsButtonTitle]];
    [moreOptions addButtonWithTitle:[self thirdMoreOptionsButtonTitle]];
  }
  [moreOptions addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
  moreOptions.cancelButtonIndex = showShareButtons ? 3 : 1;
  return moreOptions;
}

- (void)deletePhoto {
  APPSPhotoModel *deletedPhoto = self.selectedPhoto;
  [self deletePhoto:deletedPhoto];
}

- (void)deletePhoto:(APPSPhotoModel *)deletedPhoto {
  APPSRACBaseRequest *destroyRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              params:nil
              method:HTTPMethodDELETE
             keyPath:[NSString stringWithFormat:kDestroyPhotoKeyPath,
                                                (unsigned long)self.selectedPhoto.photoId]
          disposable:nil];
  @weakify(self);
  [destroyRequest.execute subscribeNext:^(id x) {
    @strongify(self);
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kDeleteProfilePhotoNotificationName
                      object:self
                    userInfo:@{kDeleteProfilePhotoNotificationKey : deletedPhoto}];
    [self deletePhotoFromPhotoModels:deletedPhoto];
  } error:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

- (void)deletePhotoFromPhotoModels:(APPSPhotoModel *)deletedPhoto {
  NSUInteger deletedIndex = [self findPhotoIndex:deletedPhoto];
  if (deletedIndex != NSNotFound) {
    [self.photoModels removeObjectAtIndex:deletedIndex];
    if ([self isMemberOfClass:[APPSProfileViewControllerDelegate class]]) {
      [self.user setPhotosCount:@([self.user.photosCount unsignedIntegerValue] - 1)];
    }
    if (self.photoModels.count == 0) {
      [self resetProperties];
    }
    [self reloadIfOnScreen];
  }
}

- (NSUInteger)findPhotoIndex:(APPSPhotoModel *)photo {
  __block NSUInteger index = NSNotFound;
  [self.photoModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    APPSPhotoModel *currentPhoto = (APPSPhotoModel *)obj;
    if (currentPhoto.photoId == photo.photoId) {
      *stop = YES;
      index = idx;
    }
  }];
  return index;
}

- (void)markPhotoAsInappropriate {
  UIAlertView *alert = [[UIAlertView alloc]
          initWithTitle:nil
                message:NSLocalizedString(
                            @"Are you sure you want to mark this " @"image as inappropriate?", nil)
               delegate:self
      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
      otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
  [alert show];
}

- (void)tapsFirstMoreOptionsActionSheetButton {
  if ([self.selectedPhoto.user.userId unsignedIntegerValue] ==
      [[[[APPSCurrentUserManager sharedInstance] currentUser] userId] unsignedIntegerValue]) {
    [self deletePhoto];
    self.selectedPhoto = nil;
  } else {
    [self markPhotoAsInappropriate];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  NSInteger kFirstButtonIndex = 0, kShareTwitterIndex = 1, kShareFacebookIndex = 2;
  if (buttonIndex == kFirstButtonIndex) {
    [self tapsFirstMoreOptionsActionSheetButton];
  } else if (buttonIndex != actionSheet.cancelButtonIndex) {
    [self registerForPhotoSgaringFinishedNotification];
    self.spinnerView = _spinnerView
                           ? _spinnerView
                           : [[APPSSpinnerView alloc]
                                 initWithSuperview:self.parentController.tabBarController.view];
    [self.spinnerView startAnimating];

    APPSPhotoModel *selectedPhoto = self.selectedPhoto;
    if (buttonIndex == kShareTwitterIndex) {
      @weakify(self);
      [[[APPSUtilityFactory sharedInstance] imageUtility]
          createBlurredPhotoWithTagline:selectedPhoto.tagLine
                               imageURL:selectedPhoto.URL
                             completion:^(UIImage *image, NSError *error) {
                               @strongify(self);
                               selectedPhoto.blurredImage = image;
                               [[[APPSUtilityFactory sharedInstance] twitterUtility]
                                   authorizeAndPublishPhoto:selectedPhoto
                                                 completion:^(BOOL success) {
                                                   [self showSharePhotoAlertWithStatus:success];
                                                 }];
                             }];
    } else if (buttonIndex == kShareFacebookIndex) {
      @weakify(self);
      [[[APPSUtilityFactory sharedInstance] imageUtility]
          createBlurredPhotoWithTagline:selectedPhoto.tagLine
                               imageURL:selectedPhoto.URL
                             completion:^(UIImage *image, NSError *error) {
                               @strongify(self);
                               selectedPhoto.blurredImage = image;
                               [[[APPSUtilityFactory sharedInstance] facebookUtility]
                                   sharePhoto:selectedPhoto
                                   completion:^(BOOL success) {
                                     [self showSharePhotoAlertWithStatus:success];
                                   }];
                             }];
    }
    self.selectedPhoto = nil;
  }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  NSInteger okButtonIndex = 1;
  if (buttonIndex == okButtonIndex) {
    [self performPhotoComplaintRequestWithPhoto:self.selectedPhoto];
  }
  self.selectedPhoto = nil;
}

- (void)performPhotoComplaintRequestWithPhoto:(APPSPhotoModel *)photo {
  APPSRACBaseRequest *complaintRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              method:HTTPMethodPOST
             keyPath:[NSString
                         stringWithFormat:kPhotoComplaintKeyPath, (unsigned long)photo.photoId]
          disposable:nil];
  [[complaintRequest execute] subscribeNext:^(id _) {
    UIAlertView *successAlert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:NSLocalizedString(@"Thank you. We will check and "
                                                             @"remove this image if it "
                                                             @"violates our privacy policy",
                                                             nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                         otherButtonTitles:nil];
    [successAlert show];
  } error:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

- (void)showSharePhotoAlertWithStatus:(BOOL)success {
  NSString *message = NSLocalizedString(@"Photo has been successfully shared.", nil);
  if (!success) {
    message = NSLocalizedString(@"Photo has not been shared. Please try one more time.", nil);
  }
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                        otherButtonTitles:nil];
  [alert show];
}

- (APPSPhotoModel *)photoModelForCell:(UICollectionViewCell *)cell {
  NSIndexPath *cellIndexPath = [self.parentController.collectionView indexPathForCell:cell];
  if (cellIndexPath == nil) {
    return nil;
  }
  if (cellIndexPath.item >= self.photoModels.count) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Index is out of bounds"
                                 }]);
    return nil;
  }
  return self.photoModels[cellIndexPath.row];
}

#pragma mark - Photo Sharing Notification

- (void)registerForPhotoSgaringFinishedNotification {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(handlePhotoSharingFinishedNotification)
             name:photoUploadingFinishedNotification
           object:nil];
}

- (void)handlePhotoSharingFinishedNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:photoUploadingFinishedNotification
                                                object:nil];
  [self.spinnerView stopAnimating];
}

#pragma mark - Utility

- (CGRect)rectFormString:(NSAttributedString *)string
                maxWidth:(CGFloat)maxWidth
               maxHeight:(CGFloat)maxHeight
                  offset:(CGFloat)offset {
  CGRect rect = string.length == 0
                    ? CGRectMake(0, 0, 0, 0)
                    : [string boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                           options:(NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingTruncatesLastVisibleLine)
                                           context:nil];
  if (CGRectIsEmpty(rect)) {
    offset = 0.0;
  }
  rect.size.height = ceil(rect.size.height) + offset * 2;
  return rect;
}

- (NSAttributedString *)photoCommentsAttributedStringWithPhoto:(APPSPhotoModel *)photo {
  NSArray *comments = photo.comments;
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
  UIFont *font = FONT_HELVETICANEUE(15.f);
  for (NSInteger i = 0; i < comments.count; i++) {
    NSInteger viewAllCommentsIndex = 0;
    if (i == viewAllCommentsIndex && photo.commentsCount > comments.count) {
      NSAttributedString *viewAllCommentsString = [[NSAttributedString alloc]
          initWithString:@"Show all comments\n"
              attributes:@{
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : [UIColor lightGrayColor],
                kHotWordTypeAttribute : @(HotWordTypeViewAllComments)
              }];
      [str appendAttributedString:viewAllCommentsString];
    }
    APPSCommentModel *commentModel = (APPSCommentModel *)comments[i];
    NSString *extraLine = nil;
    extraLine = nil;
    NSAttributedString *username = [[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%@ ", commentModel.user.username]
            attributes:@{
              NSFontAttributeName : font,
              NSForegroundColorAttributeName :
                  [UIColor colorWithRed:0.565 green:0.078 blue:0.020 alpha:1.000],
              kHotWordValueAttribute : commentModel.user.username,
              kHotWordTypeAttribute : @(HotWordTypeUsername)
            }];
    NSMutableAttributedString *comment = [self
        parseTextOnMentionsAndHashtags:
            [commentModel.message
                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                              withFont:font];
    if (commentModel != [comments lastObject]) {
      [comment appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    [str appendAttributedString:username];
    [str appendAttributedString:comment];
  }

  return [str copy];
}

- (NSAttributedString *)photoDescriptionAttributedStringWithText:(NSString *)text {
  UIFont *font = FONT_HELVETICANEUE(15.f);
  return [[self parseTextOnMentionsAndHashtags:text withFont:font] copy];
}

- (NSMutableAttributedString *)parseTextOnMentionsAndHashtags:(NSString *)text
                                                     withFont:(UIFont *)font {
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
      initWithString:text
          attributes:@{
            NSFontAttributeName : font,
            NSForegroundColorAttributeName :
                [UIColor colorWithRed:0.188 green:0.176 blue:0.176 alpha:1.000]
          }];

  NSError *error = nil;
  NSRegularExpression *regex =
      [NSRegularExpression regularExpressionWithPattern:@"#\\w+" options:0 error:&error];
  NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];

  for (NSTextCheckingResult *match in matches) {
    [str addAttributes:@{
      NSFontAttributeName : font,
      NSForegroundColorAttributeName :
          [UIColor colorWithRed:0.565 green:0.078 blue:0.020 alpha:1.000],
      kHotWordValueAttribute : [text substringWithRange:match.range],
      kHotWordTypeAttribute : @(HotWordTypeHashtag)
    } range:match.range];
  }

  regex = [NSRegularExpression regularExpressionWithPattern:@"@\\w+" options:0 error:&error];
  matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];

  for (NSTextCheckingResult *match in matches) {
    [str addAttributes:@{
      NSFontAttributeName : font,
      NSForegroundColorAttributeName :
          [UIColor colorWithRed:0.565 green:0.078 blue:0.020 alpha:1.000],
      kHotWordValueAttribute : [text substringWithRange:match.range],
      kHotWordTypeAttribute : @(HotWordTypeMention)
    } range:match.range];
  }

  return str;
}

@end
