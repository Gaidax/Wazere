//
//  APPSPinModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinModel.h"

@implementation APPSPinModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"pinId",
    @"latitude" : @"latitude",
    @"longitude" : @"longitude",
    @"radius" : @"radius",
    @"created_at" : @"createdAt",
    @"updated_at" : @"updatedAt"
  }];
}

- (instancetype)initWithPhoto:(APPSPhotoModel *)photo {
  self = [super init];
  if (self) {
    _latitude = photo.place.latitude;
    _longitude = photo.place.longitude;
    _pinId = photo.place.pinId;
    _photos = (NSArray<APPSPhotoModel, Ignore> *)@[ photo ];
  }
  return self;
}

@end
