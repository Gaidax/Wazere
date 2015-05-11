//
//  ASSepiaFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASSepiaFilter.h"

@implementation ASSepiaFilter

- (NSString *)name {
  return FILTER_SEPIA;
}

- (NSString *)previewImage {
  return FILTER_SEPIA_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageSepiaFilter *filter = [GPUImageSepiaFilter new];

  return [filter imageByFilteringImage:image];
}

@end
