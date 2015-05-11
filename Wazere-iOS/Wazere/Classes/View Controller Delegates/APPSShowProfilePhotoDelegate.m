//
//  APPSTapableGridImageDelegate.m
//  Wazere
//
//  Created by iOS Developer on 10/31/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSShowProfilePhotoDelegate.h"
#import "APPSProfileViewController.h"
#import "APPSPhotoModel.h"
#import "APPSShowProfilePhotoRectLayout.h"
#import "APPSShowProfilePhotoLayout.h"

#import "APPSRACBaseRequest.h"

@interface APPSShowProfilePhotoDelegate ()

@property(assign, NS_NONATOMIC_IOSONLY) BOOL didUpdatePhoto;

@end

@implementation APPSShowProfilePhotoDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user
                         selectedPhoto:(APPSPhotoModel *)photo {
  self = [super initWithViewController:viewController user:user];
  if (self) {
    self.selectedPhoto = photo;
    self.parentController.title = user.username;
    self.selectedTab = APPSProfileSelectedTabTypeList;
  }
  return self;
}

- (NSString *)screenName {
    return @"Show photo";
}

- (BOOL)shouldHighlightTabbarCameraButton {
  return NO;
}

- (void)initCollectionViewLayouts {
  self.rectCollectionViewLayout = [[APPSShowProfilePhotoRectLayout alloc] init];
  self.rectCollectionViewLayout.delegate = self;
  self.squareCollectionViewLayout = nil;
  self.baseLayout = [[APPSShowProfilePhotoLayout alloc] init];
}

- (void)loadData {
  dispatch_async(dispatch_get_main_queue(),
                 ^{  //Была написана петля требующая, чтоб loadData выполнялся
      //только асинхронно
      if (self.selectedPhoto) {
        if (self.didUpdatePhoto) {
          self.photoModels = [@[self.selectedPhoto] mutableCopy];
          self.photoModelsStatusType = PhotoModelsStatusTypeNormal;
          [self.parentController reloadCollectionView];
        } else {
          [self updateLocationAndPhoto];
        }
      } else {
        self.photoModelsStatusType = PhotoModelsStatusTypeEmpty;
        [self.parentController reloadCollectionView];
      }
  });
}

- (void)deletePhotoFromPhotoModels:(APPSPhotoModel *)deletedPhoto {
  [super deletePhotoFromPhotoModels:deletedPhoto];
  [self.parentController disposeViewController];
}

#pragma mark - Reloading photo info

- (void)updateLocationAndPhoto {
  APPSRACBaseRequest *photoDataRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:KeyPathShowPhoto,
                                                (unsigned long)self.selectedPhoto.photoId]
          disposable:nil];
  @weakify(self);
  [photoDataRequest.execute subscribeNext:^(NSDictionary *response) {
      @strongify(self);
      if (!response[@"message"]) {
        NSError *error;
        APPSPhotoModel *photo = [[APPSPhotoModel alloc] initWithDictionary:response error:&error];
        if (photo) {
          self.selectedPhoto = photo;
          [[NSNotificationCenter defaultCenter]
              postNotificationName:kUpdatePhotoNotificationName
                            object:self
                          userInfo:@{kUpdatePhotoNotificationKey : photo}];
          self.user = self.selectedPhoto.user;
          self.parentController.title = self.user.username;
          self.didUpdatePhoto = YES;
          [self.parentController reloadCollectionView];
        }
      } else {
        NSLog(@"Error loading photo: %@", response[@"message"]);
      }
  } error:^(NSError *error) {
    @strongify(self);
      NSLog(@"%@", error);
      self.photoModelsStatusType = PhotoModelsStatusTypeError;
      [self.parentController reloadCollectionView];
  }];
}

@end
