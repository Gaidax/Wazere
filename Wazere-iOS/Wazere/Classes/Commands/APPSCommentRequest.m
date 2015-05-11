//
//  APPSCommentRequest.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCommentRequest.h"

@implementation APPSCommentRequest

- (NSDictionary *)mapResponse:(NSDictionary *)obj {
  NSError *error;
  NSArray *commentModels =
      [APPSCommentModel arrayOfModelsFromDictionaries:obj[@"comments"] error:&error];
  NSNumber *commentsCount = obj[@"comments_count"];
  if (!commentModels || !commentsCount) {
    return nil;
  }
  return @{ @"commentModels" : commentModels, @"commentsCount" : commentsCount };
}

@end
