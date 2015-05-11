//
//  APPSFiltersSegueState.m
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFiltersSegueState.h"

#import "APPSCameraConstants.h"

#import "APPSSharePhotoContainerDelegate.h"
#import "APPSSharePhotoContainerSegueState.h"
#import "APPSSharePhotoContainerViewConfigurator.h"

#import "APPSTopBarContainerViewController.h"
#import "APPSFiltersViewController.h"

#import "APPSMapViewController.h"
#import "APPSCameraMapConfigurator.h"
#import "APPSCameraMapDelegate.h"

@interface APPSFiltersSegueState ()

@end

@implementation APPSFiltersSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:kSharePhotoSegue]) {
    [self handleSharePhotoSegue:segue];
  }
}

- (void)handleSharePhotoSegue:(UIStoryboardSegue *)segue {
  APPSFiltersViewController *sourceController = [segue sourceViewController];
  APPSTopBarContainerViewController *containerController =
      (APPSTopBarContainerViewController *)[segue destinationViewController];
  containerController.configurator = [[APPSSharePhotoContainerViewConfigurator alloc] init];
  containerController.state = [[APPSSharePhotoContainerSegueState alloc] init];
  APPSSharePhotoContainerDelegate *delegate = [[APPSSharePhotoContainerDelegate alloc] init];
  delegate.savedImage = sourceController.savedImage;
  delegate.parentController = containerController;
  containerController.delegate = delegate;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

@end
