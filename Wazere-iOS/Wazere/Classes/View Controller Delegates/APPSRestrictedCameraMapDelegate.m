//
//  APPSRestictedCameraMapDelegate.m
//  Wazere
//
//  Created by iOS Developer on 12/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSRestrictedCameraMapDelegate.h"
#import "APPSMapViewAnnotation.h"
#import "CLLocation+NaN.h"

@implementation APPSRestrictedCameraMapDelegate

- (NSString *)screenName {
    return @"Choose new location for public photo";
}

- (void)updateUserLocation {
  [super updateUserLocation];
  CLLocationCoordinate2D userCoordinate = self.coordinate.coordinate;

  MKCircle *overlay = [MKCircle circleWithCenterCoordinate:userCoordinate radius:kOverlayRadius];
  [self.parentController.mapView addOverlay:overlay];
  [self.parentController.mapView
      setRegion:MKCoordinateRegionMakeWithDistance(userCoordinate, kRadius * 2.0, kRadius * 2.0)
       animated:NO];
}

- (void)checkNewCoordinate:(CLLocationCoordinate2D)newCoordinate
                 onMapView:(MKMapView *)mapView
         forAnnotationView:(MKAnnotationView *)annotationView {
  CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude
                                                       longitude:newCoordinate.longitude];
  CLLocation *oldLocation =
      [[CLLocation alloc] initWithLatitude:self.coordinate.coordinate.latitude
                                 longitude:self.coordinate.coordinate.longitude];
  CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
  if (isnan(distance)) {
    distance = [newLocation apps_distanceFromLocation:oldLocation];
  }
  if (distance > kRadius) {
    id<MKAnnotation> oldAnnotation = annotationView.annotation;
    [annotationView setAnnotation:[[APPSMapViewAnnotation alloc]
                                      initWithTitle:NSLocalizedString(@"Photo Location", nil)
                                           subtitle:@""
                                      andCoordinate:self.nextCoordinate
                                              place:nil]];
    [mapView addAnnotation:annotationView.annotation];
    [mapView removeAnnotation:oldAnnotation];
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:NSLocalizedString(@"You can't set pin here", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                         otherButtonTitles:nil];
    [alert show];
  } else {
    self.nextCoordinate = newCoordinate;
  }
}

@end
