//
//  APPSResetPasswordViewModel.m
//  Wazere
//
//  Created by iOS Developer on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSResetPasswordViewModel.h"

#import "APPSResetPasswordModel.h"
#import "APPSUsernameTableViewCellModel.h"
#import "APPSPasswordTableViewCellModel.h"

@interface APPSResetPasswordViewModel ()

@property(strong, nonatomic) APPSResetPasswordModel *model;

@end

@implementation APPSResetPasswordViewModel

- (APPSAuthCommand *)createAuthCommand {
  return [[APPSAuthCommand alloc] initWithObject:self.model
                                          method:HTTPMethodPUT
                                         keyPath:KeyPathResetPassword
                                      disposable:nil];
}

- (APPSResetPasswordModel *)createModel {
  return [APPSResetPasswordModel new];
}

- (RACSignal *)cellModels {
  APPSUsernameTableViewCellModel *userNameCellModel = [self userNameCellModel];
  APPSPasswordTableViewCellModel *passwordCellModel = [self passwordCellModel];

  APPSPasswordTableViewCellModel *temporaryPasswordCellModel = [self temporaryPasswordCellModel];

  return [RACSignal return:@[ userNameCellModel, temporaryPasswordCellModel, passwordCellModel ]];
}

- (APPSUsernameTableViewCellModel *)userNameCellModel {
  @weakify(self);
  APPSUsernameTableViewCellModel *userNameCellModel = [[APPSUsernameTableViewCellModel alloc] init];
  userNameCellModel.textFieldPlaceholder = NSLocalizedString(@"Enter username", nil);
  userNameCellModel.returnKeyType = UIReturnKeyNext;
  userNameCellModel.leftImage = [UIImage imageNamed:SIGN_UP_USERNAME_FIELD_LEFT_IMAGE_NAME];
  [RACObserve(userNameCellModel, textFieldText) subscribeNext:^(NSString *username) {
      @strongify(self);
      self.model.userName = username;
  }];
  return userNameCellModel;
}

- (APPSPasswordTableViewCellModel *)passwordCellModel {
  @weakify(self);
  APPSPasswordTableViewCellModel *passwordCellModel = [[APPSPasswordTableViewCellModel alloc] init];
  passwordCellModel.textFieldPlaceholder = NSLocalizedString(@"Create new password", nil);
  passwordCellModel.leftImage = [UIImage imageNamed:SIGN_UP_PASSWORD_FIELD_LEFT_IMAGE_NAME];
  passwordCellModel.returnKeyType = UIReturnKeyDone;
  passwordCellModel.secureTextEntry = YES;
  [RACObserve(passwordCellModel, textFieldText) subscribeNext:^(NSString *password) {
      @strongify(self);
      self.model.userPassword = password;
  }];
  return passwordCellModel;
}

- (APPSPasswordTableViewCellModel *)temporaryPasswordCellModel {
  @weakify(self);
  APPSPasswordTableViewCellModel *temporaryPasswordCellModel =
      [[APPSPasswordTableViewCellModel alloc] init];
  temporaryPasswordCellModel.textFieldPlaceholder =
      NSLocalizedString(@"Enter temporary password", nil);
  temporaryPasswordCellModel.leftImage =
      [UIImage imageNamed:SIGN_UP_TEMPORARY_PASSWORD_FIELD_LEFT_IMAGE_NAME];
  temporaryPasswordCellModel.returnKeyType = UIReturnKeyNext;
  temporaryPasswordCellModel.secureTextEntry = YES;
  [RACObserve(temporaryPasswordCellModel, textFieldText) subscribeNext:^(NSString *password) {
      @strongify(self);
      self.model.temporaryPassword = password;
  }];
  return temporaryPasswordCellModel;
}

- (RACCommand *)createPhotoCommand {
  return nil;
}

@end
