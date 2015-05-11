//
//  APPSUserLocationAnnotation.h
//  Wazere
//
//  Created by iOS Developer on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSUserLocationAnnotation : NSObject<MKAnnotation>

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                andCoordinate:(CLLocationCoordinate2D)coordinate;

@end
