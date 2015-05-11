//
//  APPSLocationManagerUtility.m
//  Wazere
//
//  Created by iOS Developer on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSLocationManagerUtility.h"
#import "APPSRACBaseRequest.h"

@interface APPSLocationManagerUtility () <CLLocationManagerDelegate>

@property(strong, NS_NONATOMIC_IOSONLY) CLLocationManager *standartLocationManager;
@property(strong, NS_NONATOMIC_IOSONLY) CLLocationManager *significantLocationManager;
@property(copy, NS_NONATOMIC_IOSONLY) LocationManagerUtilityHandler handler;

@end

@implementation APPSLocationManagerUtility

#pragma Location services

- (void)dealloc {
  [_standartLocationManager stopUpdatingLocation];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _significantLocationManager = [[CLLocationManager alloc] init];
      _significantLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([_significantLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      [_significantLocationManager requestAlwaysAuthorization];
    }
    _significantLocationManager.delegate = self;
    [_significantLocationManager startMonitoringSignificantLocationChanges];
  }
  return self;
}

- (BOOL)checkLocationServices {
  if ([CLLocationManager locationServicesEnabled] == NO) {
    return NO;
  }
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if (status != kCLAuthorizationStatusAuthorized &&
      status != kCLAuthorizationStatusAuthorizedWhenInUse &&
      status != kCLAuthorizationStatusNotDetermined) {
    return NO;
  }
  return YES;
}

- (void)showLocationManagerErrorMessage {
  UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:nil
                                 message:NSLocalizedString(@"Location services are disabled", nil)
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                       otherButtonTitles:nil];
  [alert show];
}

- (void)startStandardUpdatesWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                                 distanceFilter:(CLLocationDistance)distance
                                        handler:(LocationManagerUtilityHandler)handler {
  if ([self checkLocationServices] == NO) {
    [self showLocationManagerErrorMessage];
    [self performHandlerWithLocation:nil
                               error:[NSError errorWithDomain:@"APPSLocationManagerUtility"
                                                         code:kLocationServiceUnaviableErrorCode
                                                     userInfo:@{
                                                       NSLocalizedFailureReasonErrorKey :
                                                           @"Location services unaviable"
                                                     }]];
    return;
  }
  if (self.handler != NULL) {
    NSError *error =
        [NSError errorWithDomain:@"APPSLocationManagerUtility"
                            code:1
                        userInfo:@{
                          NSLocalizedFailureReasonErrorKey : @"Location manager already in use"
                        }];
    NSLog(@"%@", error);
    [self performHandlerWithLocation:nil error:error];
    return;
  }
  self.handler = handler;
  // Create the location manager if this object does not
  // already have one.
  if (nil == self.standartLocationManager) {
    self.standartLocationManager = [[CLLocationManager alloc] init];
    if ([self.standartLocationManager
            respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
      [self.standartLocationManager requestWhenInUseAuthorization];
    }
  }

  self.standartLocationManager.delegate = self;
  self.standartLocationManager.desiredAccuracy = desiredAccuracy;

  // Set a movement threshold for new events.
  self.standartLocationManager.distanceFilter = distance;  // meters

  [self.standartLocationManager startUpdatingLocation];
}

- (void)performHandlerWithLocation:(CLLocation *)location error:(NSError *)error {
  if (self.handler) {
    self.handler(location, error);
  }
}

- (void)updateServerLocationInformation:(CLLocation *)location {
  APPSRACBaseRequest *locationUpdateRequest =
      [[APPSRACBaseRequest alloc] initWithObject:nil
                                          params:nil
                                          method:HTTPMethodGET
                                         keyPath:KeyPathTeaserCheck
                                      disposable:nil];
  [locationUpdateRequest.execute subscribeNext:^(NSDictionary *response){}];
}

- (void)stopUpdates {
  self.handler = nil;
  [self.standartLocationManager stopUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  // If it's a relatively recent event, turn off updates to save power.
  CLLocation *location = [locations lastObject];
  NSDate *eventDate = location.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  if (abs(howRecent) < 15.0) {
    // If the event is recent, do something with it.
    if (location) {
          self.currentLocation = location;
      if (manager == self.significantLocationManager) {
        [self updateServerLocationInformation:location];
      } else {
        [self performHandlerWithLocation:location error:nil];
      }
    }
  }
  if (self.currentLocation == nil && location && manager == self.significantLocationManager) {
    self.currentLocation = location;
    [self updateServerLocationInformation:location];
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"%@", error);
  [self performHandlerWithLocation:nil error:error];
}

@end
