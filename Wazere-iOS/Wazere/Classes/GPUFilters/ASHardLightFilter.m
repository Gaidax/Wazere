//
//  ASHardLightFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASHardLightFilter.h"

@implementation ASHardLightFilter

- (NSString *)name {
  return FILTER_HARD_LIGHT;
}

- (NSString *)previewImage {
  return FILTER_HARD_LIGHT_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageContrastFilter *filter = [GPUImageContrastFilter new];
  filter.contrast = 1.5;

  return [filter imageByFilteringImage:image];
}

@end
