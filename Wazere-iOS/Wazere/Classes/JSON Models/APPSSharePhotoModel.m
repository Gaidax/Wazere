//
//  APPSSharePhotoModel.m
//  Wazere
//
//  Created by iOS Developer on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoModel.h"

@implementation APPSSharePhotoModel

- (void)setLocation:(CLLocation<Ignore> *)location {
  if (_location != location) {
    _location = location;
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
  }
}

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"photo[latitude]" : @"latitude",
    @"photo[longitude]" : @"longitude",
    @"photo[tagline]" : @"tagline",
    @"photo[description]" : @"photoDescription",
    @"photo[public]" : @"isPublic",
    @"photo[surprise]" : @"isSurprise",
    @"photo[location]" : @"locationName",
    @"friend_ids" : @"friendIds",
    @"photo[hide_location]" : @"hideLocation"
  }];
}

@end
