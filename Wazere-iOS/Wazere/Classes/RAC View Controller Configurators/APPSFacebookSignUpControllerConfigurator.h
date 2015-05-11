//
//  APPSFacebookSignUpControllerConfigurator.h
//  Wazere
//
//  Created by iOS Developer on 9/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSSignUpControllerConfigurator.h"

@interface APPSFacebookSignUpControllerConfigurator : APPSSignUpControllerConfigurator

- (instancetype)initWithUser:(APPSCurrentUser *)user NS_DESIGNATED_INITIALIZER;

@end
