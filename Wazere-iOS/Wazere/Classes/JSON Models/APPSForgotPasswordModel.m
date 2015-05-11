//
//  APPSForgotPasswordModel.m
//  Wazere
//
//  Created by Petr Yanenko on 9/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSForgotPasswordModel.h"

@implementation APPSForgotPasswordModel

- (NSDictionary *)serializable {
  return [self toDictionaryWithKeys:@[ @"usernameEmail" ]];
}

@end
