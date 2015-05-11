//
//  APPSResetPasswordModel.m
//  Wazere
//
//  Created by iOS Developer on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSResetPasswordModel.h"

@implementation APPSResetPasswordModel

- (NSDictionary *)serializable {
  NSMutableDictionary *json = [NSMutableDictionary dictionaryWithCapacity:4];
  if (self.userName) {
    json[@"username"] = self.userName;
  }
  if (self.userPassword) {
    json[@"new_password"] = self.userPassword;
  }
  if (self.temporaryPassword) {
    json[@"temporary_password"] = self.temporaryPassword;
  }
  return [json copy];
}

@end
