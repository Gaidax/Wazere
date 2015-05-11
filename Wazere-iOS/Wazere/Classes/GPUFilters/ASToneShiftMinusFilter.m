//
//  ASToneShiftMinus.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASToneShiftMinusFilter.h"

@implementation ASToneShiftMinusFilter

- (NSString *)name {
  return FILTER_TONE_SHIFT_MINUS;
}

- (NSString *)previewImage {
  return FILTER_TONE_SHIFT_MINUS_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageHueFilter *filter = [GPUImageHueFilter new];
  filter.hue = 345.0;

  return [filter imageByFilteringImage:image];
}

@end
