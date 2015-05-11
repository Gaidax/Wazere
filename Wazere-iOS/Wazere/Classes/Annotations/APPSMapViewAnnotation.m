//
//  APPSMapViewAnnotation.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapViewAnnotation.h"

@implementation APPSMapViewAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                andCoordinate:(CLLocationCoordinate2D)coordinate
                        place:(APPSPinModel *)place {
  self = [super init];
  if (self) {
    _title = title;
    _subtitle = subtitle;
    _coordinate = coordinate;
    _place = place;
  }
  return self;
}

- (NSString *)description {
  return
      [NSString stringWithFormat:@"<%@: %p; coordinate = (%f, %f)>", NSStringFromClass(self.class),
                                 self, self.coordinate.latitude, self.coordinate.longitude];
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
  _coordinate = newCoordinate;
}

@end
