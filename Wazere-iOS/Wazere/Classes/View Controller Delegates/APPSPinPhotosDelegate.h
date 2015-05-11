//
//  APPSPinPhotosDelegate.h
//  Wazere
//
//  Created by iOS Developer on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSProfileViewControllerDelegate.h"

@class APPSPinModel;

@interface APPSPinPhotosDelegate : APPSProfileViewControllerDelegate

@property(strong, NS_NONATOMIC_IOSONLY) APPSPinModel *pin;

- (instancetype)initWithViewController:(UIViewController *)viewController
                                   pin:(APPSPinModel *)pin
                                photos:(NSArray *)pinPhotos;

@end
