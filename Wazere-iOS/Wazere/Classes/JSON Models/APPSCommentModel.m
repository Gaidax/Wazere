//
//  APPSCommentModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCommentModel.h"

@implementation APPSCommentModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"commentId",
    @"mine" : @"isMine",
    @"created_at" : @"createdAt",
    @"message" : @"message",
    @"user" : @"user"
  }];
}

@end
