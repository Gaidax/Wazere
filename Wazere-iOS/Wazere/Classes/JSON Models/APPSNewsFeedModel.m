//
//  APPSNewsFeedModel.m
//  Wazere
//
//  Created by Gaidax on 10/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNewsFeedModel.h"

@implementation APPSNewsFeedModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"feed_type" : @"feedType",
    @"message" : @"message",
    @"recipient" : @"recipient",
    @"feedable" : @"feedable",
    @"created_at" : @"createdAt"
  }];
}

- (void)setFeedable:(APPSFeedableModel<Optional> *)feedable {
  if ([feedable isKindOfClass:[APPSFeedableModel class]]) {
    _feedable = feedable;
  } else {
    _feedable = [[APPSFeedableModel alloc] initWithDictionary:(NSDictionary *)feedable error:nil];
  }
}

@end
