//
//  APPSTapableGridImageDelegate.h
//  Wazere
//
//  Created by iOS Developer on 10/31/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileViewControllerDelegate.h"

@class APPSPhotoModel;

@interface APPSShowProfilePhotoDelegate : APPSProfileViewControllerDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user
                         selectedPhoto:(APPSPhotoModel *)photo;

@end
