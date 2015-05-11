//
//  ASContrastFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASContrastFilter.h"

@implementation ASContrastFilter

- (NSString *)name {
  return FILTER_CONTRAST;
}

- (NSString *)previewImage {
  return FILTER_CONTRAST_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageGammaFilter *filter = [GPUImageGammaFilter new];
  filter.gamma = 1.5;

  return [filter imageByFilteringImage:image];
}

@end
