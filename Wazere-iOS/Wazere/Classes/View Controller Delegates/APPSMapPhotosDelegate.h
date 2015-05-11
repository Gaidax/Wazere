//
//  APPSMapPhotosDelegate.h
//  Wazere
//
//  Created by iOS Developer on 10/6/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileViewControllerDelegate.h"

@interface APPSMapPhotosDelegate : APPSProfileViewControllerDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user
                              latitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude;

@end
