//
//  APPSProfileViewControllerDelegate.h
//  Wazere
//
//  Created by Bogdan Bilonog on 10/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPSViewControllerDelegate.h"
#import "APPSStrategyCollectionViewDataSource.h"
#import "APPSStrategyCollectionViewDelegate.h"
#import "APPSCollectionReusableViewDelegate.h"
#import "APPSProfileRectCollectionViewLayout.h"

typedef NS_ENUM(NSUInteger, PhotoModelsStatusType) {
  PhotoModelsStatusTypeIndefinitely,
  PhotoModelsStatusTypeNormal,
  PhotoModelsStatusTypeEmpty,
  PhotoModelsStatusTypeError
};

typedef NS_ENUM(NSUInteger, CollectionViewMode) {
  CollectionViewModeUndefined,
  CollectionViewModeRect,
  CollectionViewModeSquare
};

typedef NS_ENUM(NSInteger, APPSProfileSelectedTabType) {
  APPSProfileSelectedTabTypeGrid,
  APPSProfileSelectedTabTypeList
};

@class APPSPhotoModel, APPSPaginationModel, APPSProfileRectCollectionViewLayout, APPSGridLayout,
    APPSProfileViewController, APPSProfileRectCollectionViewCell, APPSRACBaseRequest;

@protocol APPSProfileRightButtonStrategyProtocol;

@interface APPSProfileViewControllerDelegate
    : NSObject<APPSStrategyCollectionViewDelegate, APPSStrategyCollectionViewDataSource,
               APPSCollectionReusableViewDelegate, APPSProfileRectCollectionViewLayoutDelegate>

@property(strong, nonatomic)
    id<APPSProfileRightButtonStrategyProtocol> rightNavigationButtonStrategy;

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user NS_DESIGNATED_INITIALIZER;

- (BOOL)isCurrentUser;

@end

// protected
@interface APPSProfileViewControllerDelegate ()

@property(strong, NS_NONATOMIC_IOSONLY) NSMutableArray *photoModels;
@property(strong, NS_NONATOMIC_IOSONLY) APPSPaginationModel *paginationModel;
@property(weak, NS_NONATOMIC_IOSONLY) APPSRACBaseRequest *performingPhotoRequest;
@property(weak, NS_NONATOMIC_IOSONLY) APPSRACBaseRequest *performingUserRequest;

@property(assign, NS_NONATOMIC_IOSONLY) PhotoModelsStatusType photoModelsStatusType;

@property(strong, NS_NONATOMIC_IOSONLY)
    APPSProfileRectCollectionViewLayout *rectCollectionViewLayout;
@property(strong, NS_NONATOMIC_IOSONLY) APPSGridLayout *squareCollectionViewLayout;
@property(strong, NS_NONATOMIC_IOSONLY) APPSProfileCollectionViewLayout *baseLayout;

@property(strong, NS_NONATOMIC_IOSONLY) APPSPhotoModel *selectedPhoto;
@property(assign, NS_NONATOMIC_IOSONLY) CollectionViewMode viewMode;
@property(assign, nonatomic) APPSProfileSelectedTabType selectedTab;

@property(strong, NS_NONATOMIC_IOSONLY) id<APPSUserProtocol> user;

- (void)loadPhotos;
- (void)loadData;
- (void)deletePhoto;
- (UIActionSheet *)moreOptionsActionSheet;
- (void)forceCollectionViewReload:(NSNotification *)notification;
- (void)changeCollectionViewLayoutWithViewMode:(CollectionViewMode)viewMode;
- (void)tapsFirstMoreOptionsActionSheetButton;
- (void)deletePhotoFromPhotoModels:(APPSPhotoModel *)deletedPhoto;

// empty screen methods
- (BOOL)shouldShowEmptyScreen;
- (BOOL)shouldHighlightTabbarCameraButton;
- (NSString *)emptyMessage;
- (NSString *)emptyTitle;
- (BOOL)shouldShowTopImage;
- (BOOL)shouldShowBottomImage;
@end
