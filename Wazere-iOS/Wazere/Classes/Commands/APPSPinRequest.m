//
//  APPSPinRequest.m
//  Wazere
//
//  Created by iOS Developer on 9/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinRequest.h"

@implementation APPSPinRequest

- (APPSPhotosModel *)mapResponse:(NSDictionary *)objs {
  NSError *error = nil;
  return [[APPSPhotosModel alloc] initWithDictionary:objs error:&error];
}

@end
