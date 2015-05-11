//
//  APPSSignInModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignInModel.h"

@implementation APPSSignInModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"username" : @"usernameEmail",
    @"password" : @"userPassword",
    @"device_token" : @"deviceToken"
  }];
}

@end
