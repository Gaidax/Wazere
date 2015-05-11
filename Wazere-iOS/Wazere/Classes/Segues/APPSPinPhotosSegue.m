//
//  APPSPinPhotosSegue.m
//  Wazere
//
//  Created by iOS Developer on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinPhotosSegue.h"
#import "APPSMapViewController.h"
#import "APPSPinPhotosController.h"

@implementation APPSPinPhotosSegue

- (void)perform {
  APPSMapViewController *controller = (APPSMapViewController *)[self sourceViewController];
  APPSPinPhotosController *pinController =
      (APPSPinPhotosController *)[self destinationViewController];
  [controller addChildViewController:pinController];
  [pinController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [controller.view addSubview:pinController.view];
  NSDictionary *views = @{ @"view" : pinController.view };
  [controller.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
  [controller.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
  [pinController didMoveToParentViewController:controller];
}

@end
