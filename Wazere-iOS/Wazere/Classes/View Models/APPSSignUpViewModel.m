//
//  APPSSignUpViewModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignUpViewModel.h"

#import "APPSEmailTableViewCellModel.h"
#import "APPSUsernameTableViewCellModel.h"
#import "APPSPasswordTableViewCellModel.h"

@interface APPSSignUpViewModel ()

@property(strong, nonatomic) RACSignal *isPasswordConfirmed;
@property(strong, nonatomic) APPSSignUpModel *model;
@property(strong, nonatomic) APPSMultipartCommand *authCommand;

@end

@implementation APPSSignUpViewModel

@synthesize objects = _objects;

#pragma mark - Init

- (instancetype)init {
  self = [super init];

  if (self) {
    self.model = [self createModel];

    RAC(self, objects) = [self cellModels];

    _signUpCommand = [self createSignUpCommand];

    _addPhotoCommand = [self createPhotoCommand];
  }

  return self;
}

- (APPSSignUpModel *)createModel {
  APPSSignUpModel *model = [[APPSSignUpModel alloc] init];
  [RACObserve(self, userImage)
      subscribeNext:^(UIImage *userImage) { model.userImage = userImage; }];
  return model;
}

- (RACCommand *)createPhotoCommand {
  @weakify(self);
  return [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
      @strongify(self);
      return [self actionSheet];
  }];
}

- (APPSMultipartCommand *)createAuthCommandWithModel:(APPSSignUpModel *)model {
  return [[APPSMultipartCommand alloc] initWithObject:model
                                               params:nil
                                               method:HTTPMethodPOST
                                              keyPath:KeyPathSignUp
                                            imageName:@"avatar"
                                           disposable:nil];
}

- (APPSMultipartCommand *)createAuthCommand {
  return [self createAuthCommandWithModel:self.model];
}

- (RACCommand *)createSignUpCommand {
  @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
        @strongify(self);
        self.authCommand = [self createAuthCommand];
        return [self.authCommand.execute materialize];
    }];
}

- (RACSignal *)cellModels {
  APPSEmailTableViewCellModel *emailCellModel = [self emailCellModel];

  APPSUsernameTableViewCellModel *userNameCellModel = [self usernameTableViewCellModel];

  APPSPasswordTableViewCellModel *passwordCellModel = [self passwordCellModel];
  return [RACSignal return:@[ emailCellModel, userNameCellModel, passwordCellModel ]];
}

- (APPSEmailTableViewCellModel *)emailCellModel {
  APPSEmailTableViewCellModel *emailCellModel = [[APPSEmailTableViewCellModel alloc] init];
  emailCellModel.returnKeyType = UIReturnKeyNext;
  emailCellModel.keyboardType = UIKeyboardTypeEmailAddress;
  emailCellModel.textFieldPlaceholder = SIGN_UP_EMAIL_PLACEHOLDER;
  emailCellModel.leftImage = [UIImage imageNamed:SIGN_UP_EMAIL_FIELD_LEFT_IMAGE_NAME];
  @weakify(self);
  [RACObserve(emailCellModel, textFieldText) subscribeNext:^(NSString *email) {
      @strongify(self);
      self.model.userEmail = email;
  }];
  return emailCellModel;
}

- (APPSUsernameTableViewCellModel *)usernameTableViewCellModel {
  APPSUsernameTableViewCellModel *userNameCellModel = [[APPSUsernameTableViewCellModel alloc] init];
  userNameCellModel.returnKeyType = UIReturnKeyNext;
  userNameCellModel.textFieldPlaceholder = SIGN_UP_USERNAME_PLACEHOLDER;
  userNameCellModel.leftImage = [UIImage imageNamed:SIGN_UP_USERNAME_FIELD_LEFT_IMAGE_NAME];
  @weakify(self);
  [RACObserve(userNameCellModel, textFieldText) subscribeNext:^(NSString *username) {
      @strongify(self);
      self.model.userName = username;
  }];
  return userNameCellModel;
}

- (APPSPasswordTableViewCellModel *)passwordCellModel {
  APPSPasswordTableViewCellModel *passwordCellModel = [[APPSPasswordTableViewCellModel alloc] init];
  passwordCellModel.returnKeyType = UIReturnKeyDone;
  passwordCellModel.secureTextEntry = YES;
  passwordCellModel.textFieldPlaceholder = SIGN_UP_PASSWORD_PLACEHOLDER;
  passwordCellModel.leftImage = [UIImage imageNamed:SIGN_UP_PASSWORD_FIELD_LEFT_IMAGE_NAME];
  @weakify(self);
  [RACObserve(passwordCellModel, textFieldText) subscribeNext:^(NSString *password) {
      @strongify(self);
      self.model.userPassword = password;
  }];
  return passwordCellModel;
}

#pragma mark - Photo signals

- (RACSignal *)actionSheet {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:@"Change profile picture"
                                  delegate:nil
                         cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                         otherButtonTitles:@"Take photo", @"Choose from Library", nil];

  return [RACSignal return:actionSheet];
}

- (RACSignal *)imagePickerController:(NSUInteger)type {
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  switch (type) {
    case 0:
      if (![UIImagePickerController
              isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return [RACSignal return:nil];
      }
      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
      break;

    case 1:
      if (![UIImagePickerController
              isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return [RACSignal return:nil];
      }
      imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      break;

    case 2:
      return [RACSignal return:nil];
  }

  imagePickerController.mediaTypes = @[ (NSString *)kUTTypeImage ];

  imagePickerController.allowsEditing = YES;

  return [RACSignal return:imagePickerController];
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
}

@end
