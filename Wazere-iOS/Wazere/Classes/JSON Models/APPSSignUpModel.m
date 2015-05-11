//
//  APPSSignUpModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignUpModel.h"

@implementation APPSSignUpModel

- (instancetype)init {
  self = [super init];
  if (self) {
    @weakify(self);
    [RACObserve(self, userImage) subscribeNext:^(UIImage *userImage) {
        @strongify(self);
        if (userImage) {
          self.images = @[ userImage ];
        } else {
          self.images = nil;
        }
    }];
  }
  return self;
}

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"email" : @"userEmail",
    @"username" : @"userName",
    @"password" : @"userPassword",
    @"confirm_password" : @"userConfirmPassword",
    @"device_token" : @"deviceToken"
  }];
}

@end
