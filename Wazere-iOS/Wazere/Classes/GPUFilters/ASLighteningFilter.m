//
//  ASLighteningFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASLighteningFilter.h"

@implementation ASLighteningFilter

- (NSString *)name {
  return FILTER_LIGHTENING;
}

- (NSString *)previewImage {
  return FILTER_LIGHTENING_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageToneCurveFilter *filter = [GPUImageToneCurveFilter new];

  CGPoint first = CGPointMake(0, 0.1);
  CGPoint second = CGPointMake(0.5, 0.6);
  CGPoint third = CGPointMake(1, 1);

  filter.rgbCompositeControlPoints = @[
    [NSValue valueWithCGPoint:first],
    [NSValue valueWithCGPoint:second],
    [NSValue valueWithCGPoint:third]
  ];

  return [filter imageByFilteringImage:image];
}

@end
