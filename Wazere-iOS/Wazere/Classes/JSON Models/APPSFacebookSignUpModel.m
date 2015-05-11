//
//  APPSFacebookSignUpModel.m
//  Wazere
//
//  Created by Petr Yanenko on 1/21/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSFacebookSignUpModel.h"

@implementation APPSFacebookSignUpModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                     @"username" : @"userName",
                                                     @"password" : @"userPassword",
                                                     @"confirm_password" : @"userConfirmPassword",
                                                     @"device_token" : @"deviceToken"
                                                     }];
}

@end
