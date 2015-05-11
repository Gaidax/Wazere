//
//  APPSLocationManagerUtility.h
//  Wazere
//
//  Created by iOS Developer on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const kLocationServiceUnaviableErrorCode = 0;

typedef void (^LocationManagerUtilityHandler)(CLLocation *location, NSError *error);

@interface APPSLocationManagerUtility : NSObject

@property(strong, nonatomic) CLLocation *currentLocation;

- (void)startStandardUpdatesWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                                 distanceFilter:(CLLocationDistance)distance
                                        handler:(LocationManagerUtilityHandler)handler;
- (void)stopUpdates;

@end
