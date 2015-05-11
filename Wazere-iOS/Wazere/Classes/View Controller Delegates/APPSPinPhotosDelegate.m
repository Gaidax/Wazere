//
//  APPSPinPhotosDelegate.m
//  Wazere
//
//  Created by iOS Developer on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinPhotosDelegate.h"
#import "APPSProfileViewController.h"
#import "APPSShowProfilePhotoLayout.h"
#import "APPSPinPhotosGridLayout.h"
#import "APPSPinModel.h"

@interface APPSPinPhotosDelegate ()

@end

@implementation APPSPinPhotosDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                   pin:(APPSPinModel *)pin
                                photos:(NSArray *)pinPhotos {
  self = [super initWithViewController:viewController
                                  user:[[APPSCurrentUserManager sharedInstance] currentUser]];
  if (self) {
    _pin = pin;
    super.selectedTab = APPSProfileSelectedTabTypeGrid;
  }
  return self;
}

- (void)initCollectionViewLayouts {
  self.rectCollectionViewLayout = nil;
  self.squareCollectionViewLayout = [[APPSPinPhotosGridLayout alloc] init];
  self.baseLayout = [[APPSShowProfilePhotoLayout alloc] init];
}

- (NSString *)screenName {
    return @"Photos from pin";
}

- (BOOL)shouldHighlightTabbarCameraButton {
  return NO;
}

- (void)loadData {
  dispatch_async(dispatch_get_main_queue(),
                 ^{  //Была написана петля требующая, чтоб loadData выполнялся
      //только асинхронно
      if (self.pin.photos) {
        self.photoModels = [self.pin.photos mutableCopy];
        self.photoModelsStatusType = PhotoModelsStatusTypeNormal;
      } else {
        self.photoModels = [[NSMutableArray alloc] init];
        self.photoModelsStatusType = PhotoModelsStatusTypeEmpty;
      }
      [self.parentController reloadCollectionView];
  });
}

- (void)tapsFirstMoreOptionsActionSheetButton {
  [super tapsFirstMoreOptionsActionSheetButton];
  self.selectedPhoto = nil;
}

@end
