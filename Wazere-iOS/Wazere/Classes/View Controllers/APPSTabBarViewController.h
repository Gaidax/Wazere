//
//  APPSTabBarViewController.h
//  Wazere
//
//  Created by iOS Developer on 9/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSTabBarViewController : UITabBarController

@property(assign, NS_NONATOMIC_IOSONLY) NSUInteger previousTabIndex;

+ (APPSTabBarViewController *)rootViewController;

- (void)cleanSystemMemory;
- (void)showMapPreviousTab;

@end
