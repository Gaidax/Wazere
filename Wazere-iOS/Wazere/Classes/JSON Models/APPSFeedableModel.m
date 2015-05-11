//
//  APPSFeedableModel.m
//  Wazere
//
//  Created by Gaidax on 10/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFeedableModel.h"

@implementation APPSFeedableModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"feedableId",
    @"feedable_type" : @"feedableType",
    @"photo_url" : @"photoUrl",
    @"tagline" : @"tagline",
    @"allowed" : @"isAllowed"
  }];
}

@end