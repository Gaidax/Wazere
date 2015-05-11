//
//  ASPosterizeFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASPosterizeFilter.h"

@implementation ASPosterizeFilter

- (NSString *)name {
  return FILTER_POSTERIZE;
}

- (NSString *)previewImage {
  return FILTER_POSTERIZE_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImagePosterizeFilter *filter = [GPUImagePosterizeFilter new];

  return [filter imageByFilteringImage:image];
}

@end
