//
//  APPSSharePhotoChildSegue.m
//  Wazere
//
//  Created by iOS Developer on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSTopBarToChildSegue.h"
#import "APPSTopBarContainerViewController.h"

@implementation APPSTopBarToChildSegue

- (void)perform {
  APPSTopBarContainerViewController *sourceController = [self sourceViewController];
  UIViewController *childController = [self destinationViewController];
  [sourceController addChildViewController:childController];
  [childController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [sourceController.contentView addSubview:childController.view];
  [sourceController.contentView
      addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[child]|"
                                                             options:0
                                                             metrics:nil
                                                               views:@{
                                                                 @"child" : childController.view
                                                               }]];
  [sourceController.contentView
      addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[child]|"
                                                             options:0
                                                             metrics:nil
                                                               views:@{
                                                                 @"child" : childController.view
                                                               }]];
  [childController didMoveToParentViewController:sourceController];
}

@end
