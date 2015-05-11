//
//  APPSResetPasswordModel.h
//  Wazere
//
//  Created by iOS Developer on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@interface APPSResetPasswordModel : APPSBaseModel

@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *temporaryPassword;
@property(strong, nonatomic) NSString *userPassword;
@property(strong, nonatomic) NSString *userConfirmPassword;

@end
