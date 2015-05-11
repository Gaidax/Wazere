//
//  APPSPinPhotosChildSegue.m
//  Wazere
//
//  Created by iOS Developer on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinPhotosChildSegue.h"
#import "APPSPinPhotosController.h"
#import "APPSProfileViewController.h"

@implementation APPSPinPhotosChildSegue

- (void)perform {
  APPSPinPhotosController *controller = (APPSPinPhotosController *)[self sourceViewController];
  APPSProfileViewController *profile =
      (APPSProfileViewController *)[self destinationViewController];
  [controller addChildViewController:profile];
  [profile.view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [controller.gridView addSubview:profile.view];
  NSDictionary *views = @{ @"view" : profile.view };
  [controller.gridView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
  [controller.gridView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
  [profile didMoveToParentViewController:controller];
}

@end
