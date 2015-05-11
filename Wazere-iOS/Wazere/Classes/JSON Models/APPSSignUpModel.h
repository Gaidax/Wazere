//
//  APPSSignUpModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "APPSMultipartModel.h"

@class APPSSignUpViewModel;

@interface APPSSignUpModel : APPSMultipartModel

@end

// RAC
@interface APPSSignUpModel ()

@property(strong, nonatomic) UIImage<Ignore> *userImage;
@property(strong, nonatomic) NSString *userEmail;
@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *userPassword;
@property(strong, nonatomic) NSString *userConfirmPassword;
@property(strong, nonatomic) NSString *deviceToken;

@end
