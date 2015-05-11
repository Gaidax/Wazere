//
//  APPSLikedPhotosConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 10/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSLikedPhotosConfigurator.h"
#import "APPSProfileViewController.h"

@implementation APPSLikedPhotosConfigurator

- (void)configureViewController:(APPSProfileViewController *)controller {
  [super configureViewController:controller];
  controller.title = NSLocalizedString(@"Photos you have liked", nil);
}

@end
