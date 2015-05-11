//
//  ASGrayscaleFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASGrayscaleFilter.h"

@implementation ASGrayscaleFilter

- (NSString *)name {
  return FILTER_GRAYSCALE;
}

- (NSString *)previewImage {
  return FILTER_GRAYSCALE_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageGrayscaleFilter *filter = [GPUImageGrayscaleFilter new];

  return [filter imageByFilteringImage:image];
}

@end
