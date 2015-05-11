//
//  APPSSignInModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@interface APPSSignInModel : APPSBaseModel

@property(strong, nonatomic) NSString *usernameEmail;
@property(strong, nonatomic) NSString *userPassword;
@property(strong, nonatomic) NSString *deviceToken;

@end
