//
//  APPSFacebookSearchResult.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFacebookSearchResult.h"
#import "APPSFeedableModel.h"

@implementation APPSFacebookSearchResult

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"avatar_url" : @"avatarUrl",
    @"facebook_name" : @"facebookName",
    @"id" : @"userId",
    @"username" : @"username",
    @"photos" : @"photos"
  }];
}

- (void)setPhotos:(NSArray<Optional> *)photos {
  NSMutableArray *newPhotos = [[NSMutableArray alloc] init];
  for (id photo in photos) {
    if ([photo isKindOfClass:[APPSFeedableModel class]]) {
      [newPhotos addObject:photo];
    } else {
      [newPhotos
          addObject:[[APPSFeedableModel alloc] initWithDictionary:(NSDictionary *)photo error:nil]];
    }
  }
  _photos = [newPhotos copy];
}

@end
