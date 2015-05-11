//
//  UIImage.h
//  Wazere
//
//  Created by Petr Yanenko on 10/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (GaussianBlur)

- (UIImage *)imageWithBlurredCircleWithCenter:(CGPoint)center
                                       radius:(CGFloat)circleRadius
                                         blur:(CGFloat)blurRadius
                                   luminosity:(CGFloat)luminosity;
- (UIImage *)imageWithBlur:(CGFloat)radius luminosity:(CGFloat)luminosity;

@end
