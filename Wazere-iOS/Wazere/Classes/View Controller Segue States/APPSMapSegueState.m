//
//  APPSMapSegueState.m
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapSegueState.h"
#import "APPSMapViewController.h"
#import "APPSMapPhotoConfigurator.h"
#import "APPSMapPhotosDelegate.h"
#import "APPSProfileViewController.h"
#import "APPSAPIMapConstants.h"
#import "APPSMapDelegate.h"
#import "APPSUserLocationAnnotation.h"
#import "APPSPinPhotosController.h"

@implementation APPSMapSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  APPSMapDelegate *sourceDelegate =
      (APPSMapDelegate *)[(APPSMapViewController *)[segue sourceViewController] delegate];
  if ([segue.identifier isEqualToString:kNearbyPhotosSegue]) {
    APPSProfileViewController *controller =
        (APPSProfileViewController *)[segue destinationViewController];
    controller.configurator = [[APPSMapPhotoConfigurator alloc] init];
    APPSMapPhotosDelegate *delegate = [[APPSMapPhotosDelegate alloc]
        initWithViewController:controller
                          user:[[APPSCurrentUserManager sharedInstance] currentUser]
                      latitude:sourceDelegate.userLocation.coordinate.latitude
                     longitude:sourceDelegate.userLocation.coordinate.longitude];
    controller.delegate = delegate;
    controller.dataSource = delegate;
    controller.delegate = delegate;
  } else if ([segue.identifier isEqualToString:kPinPhotosSegue]) {
    APPSPinPhotosController *controller =
        (APPSPinPhotosController *)[segue destinationViewController];
    controller.pin = sourceDelegate.selectedPin;
  }
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
