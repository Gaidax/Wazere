//
//  APPSSettingsModel.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSettingsModel.h"

@implementation APPSSettingsModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"facebook_friends" : @"facebookFriends",
    @"likes" : @"likes",
    @"followers" : @"followers",
    @"comments" : @"comments",
    @"direct_activity" : @"directActivity"
  }];
}

@end
