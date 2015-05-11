//
//  APPSProfileConstants.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSProfileConstants_h
#define Wazere_APPSProfileConstants_h

// Collection views identifiers
static NSString *const kRectCollectionViewCell = @"APPSProfileRectCollectionViewCell";
static NSString *const kGridCollectionViewCell = @"APPSGridCell";
static NSString *const kLoadingCollectionViewCell = @"APPSLoadingCollectionViewCell";
static NSString *const kCollectionReusableView = @"APPSProfileCollectionReusableView";
static NSString *const kProfileViewControllerIdentifier = @"APPSProfileViewController";
static NSString *const kHomeFiltersTableViewCellIdentifier = @"HomeFiltersTableViewCell";

static NSString *const kFollowListTableViewCell = @"FollowListTableViewCell";
static NSString *const kFollowListLoadingCellIdentifier = @"FollowListLoadingTableViewCell";
static NSString *const kEditPhotoTableViewCell = @"EditPhotoTableViewCell";

static NSString *const kEditMyProfileSegue = @"EditMyProfileSegue";
static NSString *const kSettingsSegue = @"SettingsSegue";

static NSString *const kReloadProfileNotificationName = @"ReloadProfileNotificationName";
static NSString *const kReloadProfileNotificationKey = @"ReloadProfileNotificationKey";
static NSString *const kDeleteProfilePhotoNotificationName = @"DeleteProfilePhotoNotificationName";
static NSString *const kDeleteProfilePhotoNotificationKey = @"DeleteProfilePhotoNotificationKey";
static NSString *const kUpdatePhotoNotificationName = @"UpdatePhotoNotificationName";
static NSString *const kUpdatePhotoNotificationKey = @"UpdatePhotoNotificationKey";
static NSString *const kUpdateUserNotificationName = @"UpdateUserNotificationName";
static NSString *const kUpdateUserNotificationKey = @"UpdateUserNotificationKey";

static NSString *const kUsersInfoResponseKey = @"users";
static NSString *const kUserInfoResponseKey = @"user";

static CGFloat const ProfileHeaderViewHeight = 320.f;
static CGFloat const kFollowListCellHeight = 58.f;
static CGFloat const EditPhotoTableViewCellHeight = 130.f;
static CGFloat const HomeReusbleHeaderHeight = 50.f;

static CGFloat const kBackgroundViewTag = 1030;

static const CGFloat kDescriptionLabelWidthKoef = 280.0 / 320.0;
static const CGFloat kProfileCommentsLabelLeadingOffset = 13.0;

static NSInteger const kProfileCommentsCount = 5;

typedef NS_ENUM(NSUInteger, HotWordType) {
  HotWordTypeUndefined,
  HotWordTypeMention,
  HotWordTypeHashtag,
  HotWordTypeUsername,
  HotWordTypeViewAllComments
};

#endif
