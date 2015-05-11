//
//  APPSTopBarContainerDelegate.h
//  Wazere
//
//  Created by iOS Developer on 10/6/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewControllerDelegate.h"

@class APPSTopBarContainerViewController;

@protocol APPSTopBarContainerViewControllerDelegate<APPSViewControllerDelegate>

- (void)topBarContainerViewController:(APPSTopBarContainerViewController *)viewController
                       tapsLeftButton:(UIButton *)sender;

- (void)topBarContainerViewController:(APPSTopBarContainerViewController *)viewController
                      tapsRightButton:(UIButton *)sender;

- (void)topBarContainerViewController:(APPSTopBarContainerViewController *)viewController
                     tapsCenterButton:(UIButton *)sender;

@end
