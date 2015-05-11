//
//  APPSForgotPasswordViewModel.m
//  Wazere
//
//  Created by iOS Developer on 9/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSForgotPasswordViewModel.h"

#import "APPSUsernameEmailTableViewCellModel.h"
#import "APPSForgotPasswordModel.h"

@interface APPSForgotPasswordViewModel ()

@property(strong, nonatomic) APPSForgotPasswordModel *model;

@end

@implementation APPSForgotPasswordViewModel

- (APPSForgotPasswordModel *)createModel {
  return [[APPSForgotPasswordModel alloc] init];
}

- (APPSRACBaseRequest *)createAuthCommand {
  APPSRACBaseRequest *request =
      [[APPSRACBaseRequest alloc] initWithObject:nil
                                          params:@{
                                            @"email_username" : self.model.usernameEmail
                                          }
                                          method:HTTPMethodPOST
                                         keyPath:KeyPathForgotPassword
                                      disposable:nil];
  return request;
}

- (RACCommand *)createSignUpCommand {
  @weakify(self);
  return [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
      if (self.model.usernameEmail.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle:nil
                      message:NSLocalizedString(@"To reset your password, you "
                                                @"need to give us the email "
                                                @"address you used to create " @"your account",
                                                nil)
                     delegate:nil
            cancelButtonTitle:NSLocalizedString(@"Ok", nil)
            otherButtonTitles:nil];
        [alert show];
        return [RACSignal empty];
      }
      @strongify(self);
      self.authCommand = [self createAuthCommand];
      return [self.authCommand.execute materialize];
  }];
}

- (RACSignal *)cellModels {
  @weakify(self);

  APPSUsernameEmailTableViewCellModel *usernameEmailCellModel =
      [[APPSUsernameEmailTableViewCellModel alloc] init];
  usernameEmailCellModel.returnKeyType = UIReturnKeyDone;
  usernameEmailCellModel.keyboardType = UIKeyboardTypeEmailAddress;
  usernameEmailCellModel.textFieldPlaceholder = SIGN_IN_USERNAME_EMAIL_PLACEHOLDER;
  [RACObserve(usernameEmailCellModel, textFieldText) subscribeNext:^(NSString *usernameEmail) {
      @strongify(self);
      self.model.usernameEmail = usernameEmail;
  }];
  return [RACSignal return:@[ usernameEmailCellModel ]];
}

- (RACCommand *)createPhotoCommand {
  return nil;
}

@end
