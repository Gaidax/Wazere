//
//  APPSUserLocationAnnotation.m
//  Wazere
//
//  Created by iOS Developer on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSUserLocationAnnotation.h"

@implementation APPSUserLocationAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                andCoordinate:(CLLocationCoordinate2D)coordinate {
  self = [super init];
  if (self) {
    _title = title;
    _subtitle = subtitle;
    _coordinate = coordinate;
  }
  return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
  _coordinate = newCoordinate;
}

@end
