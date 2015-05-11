//
//  APPSCameraMapDelegate.m
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCameraMapDelegate.h"
#import "APPSMapViewAnnotation.h"

@interface APPSCameraMapDelegate ()

@end

@implementation APPSCameraMapDelegate

@synthesize parentController = _parentController;

- (instancetype)initWithParentController:(APPSMapViewController *)controller
                              coordinate:(CLLocation *)coordinate
                              completion:(PhotoLocationCompletion)completion {
  self = [super init];
  if (self) {
    _parentController = controller;
    _coordinate = coordinate;
    _completion = completion;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self initWithParentController:nil coordinate:nil completion:NULL];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
    return @"Choose new location";
}

- (void)updateUserLocation {
  [self.parentController.mapView
      addAnnotation:[[APPSMapViewAnnotation alloc]
                        initWithTitle:NSLocalizedString(@"Photo Location", nil)
                             subtitle:@""
                        andCoordinate:self.coordinate.coordinate
                                place:nil]];
  MKCoordinateRegion currentRegion = self.parentController.mapView.region;
  [self.parentController.mapView
      setRegion:MKCoordinateRegionMake(self.coordinate.coordinate, currentRegion.span)
       animated:YES];
}

- (void)checkNewCoordinate:(CLLocationCoordinate2D)newCoordinate
                 onMapView:(MKMapView *)mapView
         forAnnotationView:(MKAnnotationView *)annotationView {
  self.nextCoordinate = newCoordinate;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  if (self.coordinate && [[mapView annotations] count] == 0 &&
      mapView.region.span.latitudeDelta > 0 && mapView.region.span.longitudeDelta > 0) {
    [self updateUserLocation];
  }
}

- (void)mapViewController:(APPSMapViewController *)controller
    addAnnotationWithPlacemark:(CLPlacemark *)placemark {
  [controller.mapView removeAnnotations:[controller.mapView annotations]];
  self.nextCoordinate = placemark.location.coordinate;
  APPSMapViewAnnotation *annotation =
      [[APPSMapViewAnnotation alloc] initWithTitle:NSLocalizedString(@"Photo Location", nil)
                                          subtitle:@""
                                     andCoordinate:self.nextCoordinate
                                             place:nil];
  [controller.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  NSString *pinName = @"myPin";
  MKAnnotationView *pin =
      (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinName];
  if (pin == nil) {
    pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinName];
  } else {
    pin.annotation = annotation;
  }
  pin.draggable = YES;
  pin.canShowCallout = YES;
  self.nextCoordinate = annotation.coordinate;

  return pin;
}

- (void)mapView:(MKMapView *)mapView
        annotationView:(MKAnnotationView *)view
    didChangeDragState:(MKAnnotationViewDragState)newState
          fromOldState:(MKAnnotationViewDragState)oldState {
  if (newState == MKAnnotationViewDragStateEnding) {
    CLLocationCoordinate2D droppedAt = view.annotation.coordinate;
    [self checkNewCoordinate:droppedAt onMapView:mapView forAnnotationView:view];
  }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  return [[[APPSUtilityFactory sharedInstance] mapBlurUtility] mapView:mapView
                                                    rendererForOverlay:overlay
                                                 withClearCircleRadius:kRadius];
}

- (void)tapsDoneButton:(UIButton *)sender {
  if (self.completion) {
    self.completion(self.nextCoordinate);
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSCameraMapDelegate"
                                     code:2
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Completion is NULL"
                                 }]);
  }
  [self.parentController.presentingViewController dismissViewControllerAnimated:YES
                                                                     completion:NULL];
}

@end
