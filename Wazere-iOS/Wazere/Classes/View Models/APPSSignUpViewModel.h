//
//  APPSSignUpViewModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPSAuthViewModel.h"
#import "APPSSignUpModel.h"
#import "APPSStrategyControllerDelegate.h"

@class APPSUsernameTableViewCellModel, APPSPasswordTableViewCellModel;

@interface APPSSignUpViewModel : APPSAuthViewModel<APPSCollectionViewModel>

@property(strong, nonatomic) UIImage *userImage;

@property(strong, nonatomic) RACCommand *signUpCommand;
@property(strong, nonatomic) RACCommand *addPhotoCommand;

- (RACSignal *)imagePickerController:(NSUInteger)type;

- (APPSUsernameTableViewCellModel *)usernameTableViewCellModel;
- (APPSPasswordTableViewCellModel *)passwordCellModel;

@end
