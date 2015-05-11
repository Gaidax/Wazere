//
//  APPSHashtagModel.m
//  Wazere
//
//  Created by Gaidax on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHashtagModel.h"

@implementation APPSHashtagModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"hashtagId",
    @"name" : @"name",
    @"media_count" : @"mediaCount"
  }];
}

@end
