//
//  APPS.m
//  Wazere
//
//  Created by iOS Developer on 12/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "CLLocation+NaN.h"

@implementation CLLocation (NaN)

- (double)degreesToRadians:(CLLocationDegrees)degrees {
  return degrees / 180 * M_PI;
}

- (CLLocationDistance)apps_distanceFromLocation:(CLLocation *)location {
  CLLocationDistance earthRadius = 6371000.0;
  CLLocationDistance distance =
      acos(sin([self degreesToRadians:self.coordinate.latitude]) *
               sin([self degreesToRadians:location.coordinate.latitude]) +
           cos([self degreesToRadians:self.coordinate.latitude]) *
               cos([self degreesToRadians:location.coordinate.latitude]) *
               cos([self degreesToRadians:self.coordinate.longitude] -
                   [self degreesToRadians:location.coordinate.longitude])) *
      earthRadius;
  return distance;
}

@end
