//
//  APPSBaseModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@implementation APPSBaseModel

- (NSDictionary *)serializable {
  return [self toDictionary];
}

- (instancetype)deserializable:(NSDictionary *)params {
  return [[APPSBaseModel alloc] initWithDictionary:params error:nil];
}

@end
