//
//  APPSSignInViewControllerDelegate.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPSSignInViewModel.h"
#import "APPSStrategyControllerDelegate.h"
#import "APPSAuthViewController.h"
#import "APPSRACTableViewDelegate.h"

@interface APPSSignInViewControllerDelegate
    : NSObject<UITableViewDelegate, APPSRACTableViewDelegate>

- (instancetype)initWithController:
        (APPSAuthViewController *)viewController NS_DESIGNATED_INITIALIZER;

@end
