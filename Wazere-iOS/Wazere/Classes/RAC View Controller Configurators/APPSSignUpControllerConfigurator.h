//
//  APPSViewControllerConfigurator.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSFunctionalLogicDelegate.h"

@interface APPSSignUpControllerConfigurator : NSObject<APPSFunctionalLogicDelegate>

@end

@interface APPSSignUpControllerConfigurator ()

- (void)configureNewUserSession:(APPSCurrentUser *)user;
- (void)performSegueOnViewController:(UIViewController *)viewController;

@end
