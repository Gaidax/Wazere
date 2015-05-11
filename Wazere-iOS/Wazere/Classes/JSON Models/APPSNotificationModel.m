//
//  APPSNotificationModel.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNotificationModel.h"

@implementation APPSNotificationModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"aps" : @"additionalParams",
    @"photo_id" : @"photoId",
    @"user_id" : @"userId",
    @"photos_id" : @"photosIds",
    @"type" : @"type"
  }];
}

- (BOOL)shouldLoadPhoto {
  return [self.type isEqualToString:@"like"] || [self.type isEqualToString:@"photo"] ||
         [self.type isEqualToString:@"comments"];
}
@end
