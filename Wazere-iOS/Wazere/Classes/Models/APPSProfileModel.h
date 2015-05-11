//
//  APPSProfileModel.h
//  Wazere
//
//  Created by Petr Yanenko on 3/28/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PhotoModelsStatusType) {
  PhotoModelsStatusTypeIndefinitely,
  PhotoModelsStatusTypeNormal,
  PhotoModelsStatusTypeEmpty,
  PhotoModelsStatusTypeError
};

@class APPSPhotoModel, APPSPaginationModel, APPSRACBaseRequest;

@interface APPSProfileModel : NSObject

@property(strong, NS_NONATOMIC_IOSONLY) NSMutableArray *photoModels;
@property(strong, NS_NONATOMIC_IOSONLY) APPSPaginationModel *paginationModel;
@property(weak, NS_NONATOMIC_IOSONLY) APPSRACBaseRequest *performingPhotoRequest;
@property(weak, NS_NONATOMIC_IOSONLY) APPSRACBaseRequest *performingUserRequest;

@property(strong, NS_NONATOMIC_IOSONLY) APPSPhotoModel *selectedPhoto;

@property(assign, NS_NONATOMIC_IOSONLY) PhotoModelsStatusType photoModelsStatusType;

@property(strong, NS_NONATOMIC_IOSONLY) id<APPSUserProtocol> user;

- (instancetype)initWithUser:(id<APPSUserProtocol>)user;

- (BOOL)isCurrentUser;

- (void)resetProperties;
- (void)loadPhotos;
- (void)loadData;
- (void)deletePhoto;
- (void)deletePhotoFromPhotoModels:(APPSPhotoModel *)deletedPhoto;

@end
