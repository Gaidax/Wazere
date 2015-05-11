//
//  APPSSharePhotoSegueState.m
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoSegueState.h"
#import "APPSCameraConstants.h"
#import "APPSMapViewController.h"
#import "APPSCameraMapConfigurator.h"
#import "APPSCameraMapDelegate.h"
#import "APPSSharePhotoDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSharePhotoModel.h"
#import "APPSRestrictedCameraMapDelegate.h"
#import "APPSSearchDelegate.h"
#import "APPSRestrictedCameraMapConfigurator.h"

@implementation APPSSharePhotoSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kChooseUserLocationSegue]) {
    APPSMapViewController *map = (APPSMapViewController *)
        [[(UINavigationController *)[segue destinationViewController] viewControllers] firstObject];
    APPSStrategyTableViewController *source =
        (APPSStrategyTableViewController *)[segue sourceViewController];
    APPSSharePhotoDelegate *sourceDelegate = (APPSSharePhotoDelegate *)[source delegate];
    APPSSharePhotoModel *model = [sourceDelegate shareModel];
    PhotoLocationCompletion handler = ^(CLLocationCoordinate2D coordinate) {
        model.location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                    longitude:coordinate.longitude];
    };
    map.delegate = [[APPSRestrictedCameraMapDelegate alloc]
          initWithParentController:map
                        coordinate:sourceDelegate.userLocation
                        completion:handler];
    map.configurator = [[APPSRestrictedCameraMapConfigurator alloc] init];
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
