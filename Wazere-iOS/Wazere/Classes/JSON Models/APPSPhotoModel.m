//
//  APPSPhotoModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotoModel.h"

@implementation APPSPhotoModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"photoId",
    @"place" : @"place",
    @"created_at" : @"createdAt",
    @"description" : @"photoDescription",
    @"tagline" : @"tagLine",
    @"location" : @"location",
    @"latitude" : @"photoLatitude",
    @"longitude" : @"photoLongitude",
    @"public" : @"isPublic",
    @"allowed" : @"isAllowed",
    @"liked_by_me" : @"likedByMe",
    @"likes_count" : @"likesCount",
    @"watched_count" : @"watchedCount",
    @"photo_url" : @"URL",
    @"middle_photo_url" : @"middleURL",
    @"thumb_url" : @"thumbnailURL",
    @"comments_count" : @"commentsCount",
    @"tags" : @"tags",
    @"comments" : @"comments",
    @"user" : @"user"
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}

- (NSNumber *)photoLatitude {
  if ([_photoLatitude isEqual:[NSNull null]]) {
    return nil;
  }
  return _photoLatitude;
}

- (NSNumber *)photoLongitude {
  if ([_photoLongitude isEqual:[NSNull null]]) {
    return nil;
  }
  return _photoLongitude;
}

- (NSString *)location {
  if ([_location isEqual:[NSNull null]]) {
    return nil;
  }
  return _location;
}

@end