//
//  APPSMapBlurCircleUtility.h
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSMapBlurCircleUtility : NSObject

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
         withClearCircleRadius:(CGFloat)clearRadius;

@end
