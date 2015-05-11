//
//  APPSCameraMapDelegate.h
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSMapViewController.h"

typedef void (^PhotoLocationCompletion)(CLLocationCoordinate2D coordinate);

@interface APPSCameraMapDelegate : NSObject<APPSMapDelegate>

@property(strong, NS_NONATOMIC_IOSONLY) CLLocation *coordinate;
@property(copy, NS_NONATOMIC_IOSONLY) PhotoLocationCompletion completion;

- (instancetype)initWithParentController:(APPSMapViewController *)controller
                              coordinate:(CLLocation *)coordinate
                              completion:
                                  (PhotoLocationCompletion)completion NS_DESIGNATED_INITIALIZER;

@end

@interface APPSCameraMapDelegate ()

@property(assign, NS_NONATOMIC_IOSONLY) CLLocationCoordinate2D nextCoordinate;

- (void)updateUserLocation;

@end
