//
//  APPSMapViewAnnotation.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPSPinModel;

@interface APPSMapViewAnnotation : NSObject<MKAnnotation>

@property(strong, nonatomic) APPSPinModel *place;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                andCoordinate:(CLLocationCoordinate2D)coordinate
                        place:(APPSPinModel *)place NS_DESIGNATED_INITIALIZER;

@end
