//
//  APPSMapPhotosDelegate.m
//  Wazere
//
//  Created by iOS Developer on 10/6/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapPhotosDelegate.h"
#import "APPSRACBaseRequest.h"
#import "APPSPhotosModel.h"
#import "APPSProfileViewController.h"
#import "APPSMapPhotoRectCollectionViewLayout.h"
#import "APPSMapPhotoSquareCollectionViewLayout.h"
#import "APPSSegmentSuplementaryView.h"
#import "APPSMapPhotoCollectionViewLayout.h"
#import "APPSAPIMapConstants.h"

@interface APPSMapPhotosDelegate () <APPSSegmentSuplementaryViewDelegate>

@property(assign, nonatomic) CGFloat latitude;
@property(assign, nonatomic) CGFloat longitude;

@end

@implementation APPSMapPhotosDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user
                              latitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude {
  self = [super initWithViewController:viewController user:user];
  if (self) {
    _latitude = latitude;
    _longitude = longitude;
  }
  return self;
}

- (NSString *)screenName {
    return @"Photos on map screen";
}

- (BOOL)shouldHighlightTabbarCameraButton {
  return NO;
}

- (void)loadData {
  [self loadPhotos];
}

- (void)initCollectionViewLayouts {
  self.rectCollectionViewLayout = [[APPSMapPhotoRectCollectionViewLayout alloc] init];
  self.rectCollectionViewLayout.delegate = self;
  self.squareCollectionViewLayout = [[APPSMapPhotoSquareCollectionViewLayout alloc] init];
  self.baseLayout = [[APPSMapPhotoCollectionViewLayout alloc] init];
}

- (BOOL)openProfileForPhoto:(APPSPhotoModel *)photo {
  return YES;
}

- (void)checkUserDataAndReloadData {
  [self.parentController reloadCollectionView];
}

- (NSMutableDictionary *)addOtherParamsAtParams:(NSMutableDictionary *)params {
  if (params == nil) {
    params = [[NSMutableDictionary alloc] initWithCapacity:2];
  }
  params[@"lat"] = @(self.latitude);
  params[@"long"] = @(self.longitude);
  return params;
}

- (APPSRACBaseRequest *)photoRequestWithParams:(NSDictionary *)params {
  // MAKE PHOTO REQUEST
  APPSRACBaseRequest *photoRequest = [[APPSRACBaseRequest alloc] initWithObject:nil
                                                                         params:params
                                                                         method:HTTPMethodGET
                                                                        keyPath:kNearbyPhotosKeyPath
                                                                     disposable:nil];
  return photoRequest;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  APPSSegmentSuplementaryView *view = (APPSSegmentSuplementaryView *)
      [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                         withReuseIdentifier:kCollectionReusableView
                                                forIndexPath:indexPath];
  view.delegate = self;
  view.segmentControl.selectedSegmentIndex = (self.viewMode == CollectionViewModeRect);
  return view;
}

- (NSArray *)suplementaryViewButtonItems {
  return @[ [UIImage imageNamed:@"new_grid"], [UIImage imageNamed:@"list_view"] ];
}

#pragma mark - Empty Screen Methods

- (BOOL)shouldShowEmptyScreen {
    return self.photoModelsStatusType == PhotoModelsStatusTypeEmpty;
}

- (NSString *)emptyTitle {
    return NSLocalizedString(@"See the photos being shared near you!", @"");
}

- (NSString *)emptyMessage {
    return @"";
}

- (BOOL)shouldShowTopImage {
    return YES;
}

- (BOOL)shouldShowBottomImage {
    return NO;
}

@end
