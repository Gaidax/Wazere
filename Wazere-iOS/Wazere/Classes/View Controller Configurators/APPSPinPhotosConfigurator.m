//
//  APPSPinPhotosConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinPhotosConfigurator.h"
#import "APPSProfileViewController.h"

@implementation APPSPinPhotosConfigurator

- (void)configureViewController:(APPSProfileViewController *)controller {
  [super configureViewController:controller];
  controller.view.backgroundColor =
      [[controller.collectionView viewWithTag:kBackgroundViewTag] backgroundColor];
}

@end
