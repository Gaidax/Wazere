//
//  APPSSignInViewModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignInViewModel.h"

#import "APPSUsernameEmailTableViewCellModel.h"
#import "APPSPasswordTableViewCellModel.h"

@interface APPSSignInViewModel ()

@property(strong, nonatomic) APPSSignInModel *model;
@property(strong, nonatomic) RACSignal *isPasswordConfirmed;
@property(strong, nonatomic) APPSAuthCommand *authCommand;

@end

@implementation APPSSignInViewModel
@synthesize objects = _objects;

#pragma mark - Init

- (instancetype)init {
  self = [super init];

  if (self) {
    self.model = [[APPSSignInModel alloc] init];
    self.errorStrings = [NSMutableArray array];

    RAC(self, objects) = [self cellModels];

    _signInCommand = [self createSignInCommand];
    _forgotPasswordCommand = [self createForgotPasswordCommand];
  }

  return self;
}

- (RACCommand *)createForgotPasswordCommand {
  return [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
      return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
          [subscriber sendCompleted];
          return nil;
      }];
  }];
}

- (APPSAuthCommand *)createAuthCommandWithModel:(APPSSignInModel *)model {
  return [[APPSAuthCommand alloc] initWithObject:model
                                          params:nil
                                          method:HTTPMethodGET
                                         keyPath:KeyPathSignIn
                                      disposable:nil];
}

- (APPSAuthCommand *)createAuthCommand {
  return [self createAuthCommandWithModel:self.model];
}

- (RACCommand *)createSignInCommand {
  @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
        @strongify(self);
        self.authCommand = [self createAuthCommandWithModel:self.model];
        return [self.authCommand.execute materialize];
    }];
}

- (RACSignal *)cellModels {
  @weakify(self);

  APPSUsernameEmailTableViewCellModel *usernameEmailCellModel =
      [[APPSUsernameEmailTableViewCellModel alloc] init];
  usernameEmailCellModel.returnKeyType = UIReturnKeyNext;
  usernameEmailCellModel.keyboardType = UIKeyboardTypeEmailAddress;
  usernameEmailCellModel.textFieldPlaceholder = SIGN_IN_USERNAME_EMAIL_PLACEHOLDER;
  usernameEmailCellModel.leftImage = [UIImage imageNamed:SIGN_UP_USERNAME_FIELD_LEFT_IMAGE_NAME];
  [RACObserve(usernameEmailCellModel, textFieldText) subscribeNext:^(NSString *usernameEmail) {
      @strongify(self);
      self.model.usernameEmail = usernameEmail;
  }];

  APPSPasswordTableViewCellModel *passwordCellModel = [[APPSPasswordTableViewCellModel alloc] init];
  passwordCellModel.returnKeyType = UIReturnKeyDone;
  passwordCellModel.secureTextEntry = YES;
  passwordCellModel.textFieldPlaceholder = SIGN_IN_PASSWORD_PLACEHOLDER;
  passwordCellModel.leftImage = [UIImage imageNamed:SIGN_UP_PASSWORD_FIELD_LEFT_IMAGE_NAME];
  [RACObserve(passwordCellModel, textFieldText) subscribeNext:^(NSString *password) {
      @strongify(self);
      self.model.userPassword = password;
  }];

  return [RACSignal return:@[ usernameEmailCellModel, passwordCellModel ]];
}

@end
