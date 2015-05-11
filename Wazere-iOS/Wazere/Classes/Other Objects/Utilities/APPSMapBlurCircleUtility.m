//
//  APPSMapBlurCircleUtility.m
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapBlurCircleUtility.h"

@implementation APPSMapBlurCircleUtility

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
         withClearCircleRadius:(CGFloat)clearRadius {
  MKCircle *circleOverlay = (MKCircle *)overlay;
  MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:circleOverlay];
  renderer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.1];
  renderer.strokeColor = [UIColor clearColor];
  renderer.lineWidth = 0.0;

  CLLocationCoordinate2D circleCenterCoordinate = circleOverlay.coordinate;
  double pointsPerMeter = MKMapPointsPerMeterAtLatitude(circleCenterCoordinate.latitude);
  CGPathRef renderPath = renderer.path;
  UIBezierPath *userCirclePath = [UIBezierPath bezierPathWithCGPath:renderPath];
  UIBezierPath *circlePath = [UIBezierPath
      bezierPathWithRoundedRect:
          CGRectMake(circleOverlay.boundingMapRect.size.width / 2.0 - clearRadius * pointsPerMeter,
                     circleOverlay.boundingMapRect.size.height / 2.0 - clearRadius * pointsPerMeter,
                     clearRadius * 2.0 * pointsPerMeter, clearRadius * 2.0 * pointsPerMeter)
                   cornerRadius:clearRadius * pointsPerMeter];
  [userCirclePath appendPath:circlePath];
  renderer.path = userCirclePath.CGPath;
  return renderer;
}

@end
