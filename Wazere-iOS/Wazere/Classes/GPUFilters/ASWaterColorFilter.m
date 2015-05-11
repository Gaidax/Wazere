//
//  ASWaterColorFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASWaterColorFilter.h"

@implementation ASWaterColorFilter

- (NSString *)name {
  return FILTER_WATER_COLOR;
}

- (NSString *)previewImage {
  return FILTER_WATER_COLOR_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageKuwaharaFilter *filter = [GPUImageKuwaharaFilter new];
  filter.radius = 5.0;

  return [filter imageByFilteringImage:image];
}

@end
