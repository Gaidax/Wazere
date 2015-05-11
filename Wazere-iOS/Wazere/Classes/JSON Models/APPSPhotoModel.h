//
//  APPSPhotoModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "JSONModel.h"
#import "APPSCommentModel.h"
#import "APPSSomeUser.h"

@class APPSPinModel;

@protocol APPSPhotoModel
@end

@interface APPSPhotoModel : JSONModel

@property(assign, nonatomic) NSUInteger photoId;
@property(strong, nonatomic) APPSPinModel *place;
@property(strong, nonatomic) NSString *createdAt;
@property(strong, nonatomic) NSString<Optional> *photoDescription;
@property(strong, nonatomic) NSString *tagLine;
@property(strong, nonatomic) NSString<Optional> *location;
@property(strong, nonatomic) NSNumber<Optional> *photoLatitude;
@property(strong, nonatomic) NSNumber<Optional> *photoLongitude;
@property(assign, nonatomic) BOOL isPublic;
@property(assign, nonatomic) BOOL likedByMe;
@property(assign, nonatomic) BOOL isAllowed;
@property(assign, nonatomic) NSUInteger likesCount;
@property(assign, nonatomic) NSUInteger watchedCount;
@property(strong, nonatomic) NSURL *URL;
@property(strong, nonatomic) NSURL *middleURL;
@property(strong, nonatomic) NSURL *thumbnailURL;
@property(assign, nonatomic) NSUInteger commentsCount;
@property(strong, nonatomic) NSArray<Optional> *tags;
@property(strong, nonatomic) NSArray<APPSCommentModel, Optional> *comments;
@property(strong, nonatomic) APPSSomeUser *user;

@property(strong, nonatomic) UIImage *blurredImage;
@end
