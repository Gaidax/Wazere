//
//  APPSShowPhotoRequest.m
//  Wazere
//
//  Created by iOS Developer on 10/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotoRequest.h"
#import "APPSPhotoModel.h"

@implementation APPSPhotoRequest

- (APPSPhotoModel *)mapResponse:(NSDictionary *)objs {
  NSError *error = nil;
  return [[APPSPhotoModel alloc] initWithDictionary:objs error:&error];
}

@end
