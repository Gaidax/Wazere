//
//  APPSCameraSegueState.m
//  Wazere
//
//  Created by iOS Developer on 9/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCameraSegueState.h"

#import "APPSCameraConstants.h"
#import "APPSCameraViewController.h"
#import "APPSCropViewController.h"

#import "APPSFiltersViewController.h"
#import "APPSFiltersSegueState.h"
#import "APPSFiltersViewConfigurator.h"

#import "APPSTopBarContainerViewController.h"
#import "APPSSharePhotoContainerViewConfigurator.h"
#import "APPSSharePhotoContainerSegueState.h"

@implementation APPSCameraSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:kCameraCropSegue]) {
      [self handleCropSegue:segue];
  } else if ([[segue identifier] isEqualToString:kCameraFilterSegue]) {
      [self handleFiltersSegue:segue];
  } else if ([[segue identifier] isEqualToString:kSharePhotoSegue]) {
      [self handleSharePhotoSegue:segue];
  }
}

- (void)handleCropSegue:(UIStoryboardSegue *)segue {
    APPSCameraViewController *cameraViewController = ((APPSCameraViewController *)[segue sourceViewController]);
    APPSCropViewController *cropViewController = [segue destinationViewController];
    cropViewController.pickedImage =
    ((APPSCameraViewController *)[segue sourceViewController]).pickedImage;
    cropViewController.processingDelegate = cameraViewController;
}

- (void)handleFiltersSegue:(UIStoryboardSegue *)segue {
    APPSCameraViewController *cameraViewController = ((APPSCameraViewController *)[segue sourceViewController]);
    APPSFiltersViewController *filtersController =
    (APPSFiltersViewController *)[segue destinationViewController];
    filtersController.configurator = [[APPSFiltersViewConfigurator alloc] init];
    filtersController.state = [[APPSFiltersSegueState alloc] init];
    filtersController.pickedImage = cameraViewController.croppedImage;
    filtersController.savedImage = cameraViewController.filteredImage;
    filtersController.processingDelegate = cameraViewController;
}

- (void)handleSharePhotoSegue:(UIStoryboardSegue *)segue {
    APPSCameraViewController *sourceController = [segue sourceViewController];
    APPSTopBarContainerViewController *containerController =
    (APPSTopBarContainerViewController *)[segue destinationViewController];
    containerController.configurator = [[APPSSharePhotoContainerViewConfigurator alloc] init];
    containerController.state = [[APPSSharePhotoContainerSegueState alloc] init];
    APPSSharePhotoContainerDelegate *delegate = [[APPSSharePhotoContainerDelegate alloc] init];
    delegate.savedImage = sourceController.filteredImage;
    delegate.parentController = containerController;
    delegate.processingDelegate = sourceController;
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
