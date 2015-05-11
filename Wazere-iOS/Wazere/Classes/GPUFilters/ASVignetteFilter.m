//
//  ASVignetteFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASVignetteFilter.h"

@implementation ASVignetteFilter

- (NSString *)name {
  return FILTER_VIGNETTE;
}

- (NSString *)previewImage {
  return FILTER_VIGNETTE_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageVignetteFilter *filter = [GPUImageVignetteFilter new];

  return [filter imageByFilteringImage:image];
}

@end
