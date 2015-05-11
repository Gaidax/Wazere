//
//  APPSFacebookSignUpViewModel.m
//  Wazere
//
//  Created by iOS Developer on 9/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFacebookSignUpViewModel.h"
#import "APPSUpdateUserRequest.h"
#import "APPSAuthTableViewCellModel.h"
#import "APPSFacebookSignUpModel.h"

@implementation APPSFacebookSignUpViewModel

- (APPSRACBaseRequest *)createAuthCommandWithModel:(APPSSignUpModel *)model {
  APPSCurrentUser *user = [[APPSCurrentUserManager sharedInstance] currentUser];
  return [[APPSUpdateUserRequest alloc]
      initWithObject:model
              method:updateUserCommandMethod
             keyPath:[KeyPathUser stringByAppendingFormat:@"/%@.json", user.userId]
          disposable:nil];
}

- (RACSignal *)cellModels {

  APPSUsernameTableViewCellModel *userNameCellModel = [self usernameTableViewCellModel];

  APPSPasswordTableViewCellModel *passwordCellModel = [self passwordCellModel];
  return [RACSignal return:@[ userNameCellModel, passwordCellModel ]];
}

- (APPSSignUpModel *)createModel {
  APPSFacebookSignUpModel *model = [[APPSFacebookSignUpModel alloc] init];
  [RACObserve(self, userImage)
      subscribeNext:^(UIImage *userImage) { model.userImage = userImage; }];
  return model;
}

@end
