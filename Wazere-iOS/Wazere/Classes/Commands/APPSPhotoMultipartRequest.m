//
//  APPSPhotoMultipartRequest.m
//  Wazere
//
//  Created by iOS Developer on 10/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotoMultipartRequest.h"
#import "APPSPhotoModel.h"

@implementation APPSPhotoMultipartRequest

- (APPSPhotoModel *)mapResponse:(NSDictionary *)objs {
  NSError *error = nil;
  return [[APPSPhotoModel alloc] initWithDictionary:objs error:&error];
}

@end
