//
//  APPSTapableGridImageConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 10/31/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSShowProfilePhotoConfigurator.h"
#import "APPSProfileViewController.h"

@implementation APPSShowProfilePhotoConfigurator

- (void)configureViewController:(APPSProfileViewController *)controller {
  [super configureViewController:controller];
  controller.disposeLeftButton = YES;
  controller.navigationItem.rightBarButtonItems = nil;
}

@end
