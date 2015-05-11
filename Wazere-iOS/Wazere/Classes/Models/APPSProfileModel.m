//
//  APPSProfileModel.m
//  Wazere
//
//  Created by Petr Yanenko on 3/28/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSProfileModel.h"
#import "APPSPhotoRequest.h"
#import "APPSPhotoModel.h"
#import "APPSPaginationModel.h"
#import "APPSProfileCommand.h"

@interface APPSProfileModel ()

@property(assign, readonly, getter=isCurrentUser) BOOL isCurrentUser;

@end

@implementation APPSProfileModel

#pragma mark - Reloading

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_performingPhotoRequest cancel];
  [_performingUserRequest cancel];
}

- (instancetype)initWithUser:(id<APPSUserProtocol>)user {
  self = [super init];
  if (self) {
    _user = user;
    _photoModels = [NSMutableArray array];
  }
  return self;
}

- (void)setupNotifications {
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
      break;
    }
  }
  self.photoModelsStatusType = self.photoModelsStatusType;
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
  self.photoModelsStatusType = self.photoModelsStatusType;
}

- (void)loadData {
  [self loadProfile];
  [self loadPhotos];
}

- (void)resetProperties {
  [self.performingPhotoRequest cancel];
  [self.performingUserRequest cancel];
  self.paginationModel = [[APPSPaginationModel alloc] init];
  self.photoModelsStatusType = PhotoModelsStatusTypeIndefinitely;
  self.photoModels = [NSMutableArray array];
}

- (BOOL)isCurrentUser {
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
  return self.user ? [currentUser.userId isEqualToNumber:self.user.userId] : NO;
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
  self.photoModelsStatusType =
      self.photoModels.count == 0 ? PhotoModelsStatusTypeEmpty : PhotoModelsStatusTypeNormal;
}

- (void)executePhotoRequest:(APPSRACBaseRequest *)photoRequest {
  @weakify(self);
  [photoRequest.execute subscribeNext:^(NSDictionary *response) {
    @strongify(self);
    [self createPhotoModelsWithResponseObjects:response];
    self.performingPhotoRequest = nil;
  } error:^(NSError *error) {
    @strongify(self);
    NSLog(@"%@\nERROR! Can't load images", error);
    if (photoRequest == self.performingPhotoRequest) {
      self.photoModelsStatusType = PhotoModelsStatusTypeError;
      self.photoModels = [NSMutableArray array];
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

    self.user = user;

    switch (self.photoModelsStatusType) {
      case PhotoModelsStatusTypeError:
      case PhotoModelsStatusTypeIndefinitely:
        break;
      case PhotoModelsStatusTypeEmpty:
      case PhotoModelsStatusTypeNormal:
        self.photoModelsStatusType = self.photoModelsStatusType;
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

- (void)performProfileRequest {
  APPSSomeUser *user = (APPSSomeUser *)self.user;

  NSString *method = nil;
  if ([user.isFollowed boolValue]) {
    method = HTTPMethodDELETE;
  } else {
    method = HTTPMethodPOST;
  }

  if (user.userId == nil) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfilModel"
                                     code:6
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"User is missing"
                                 }]);
    return;
  }
  [[[APPSUtilityFactory sharedInstance] followUtility] startFollowRequestWithUser:user
                                                                           method:method
                                                                completionHandler:NULL
                                                                     errorHandler:NULL];
}

- (void)sendLikeRequestForPhoto:(APPSPhotoModel *)photoModel withLikeStatus:(BOOL)likeStatus {
  NSString *method = @"";
  NSString *keyPath =
      [NSString stringWithFormat:KeyPathPhotoLikes, (unsigned long)photoModel.photoId];

  if (likeStatus) {
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
    if ([deletedPhoto.user.userId compare:self.user.userId] == NSOrderedSame) {
      [self.user setPhotosCount:@([self.user.photosCount unsignedIntegerValue] - 1)];
    }
    if (self.photoModels.count == 0) {
      [self resetProperties];
    } else {
      self.photoModelsStatusType = self.photoModelsStatusType;
    }
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
                                                             @"violities our privacy policy",
                                                             nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                         otherButtonTitles:nil];
    [successAlert show];
  } error:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

@end
