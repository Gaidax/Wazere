//
//  APPSSignUpViewControllerDelegate.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPSSignUpViewModel.h"
#import "APPSRACTableViewDelegate.h"
#import "APPSAuthViewController.h"

@interface APPSSignUpViewControllerDelegate
    : NSObject<UITableViewDelegate, APPSRACTableViewDelegate, UITextFieldDelegate>

- (instancetype)initWithController:
        (APPSAuthViewController *)viewController NS_DESIGNATED_INITIALIZER;

@end
