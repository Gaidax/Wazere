//
//  ASToneShiftPlusFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASToneShiftPlusFilter.h"

@implementation ASToneShiftPlusFilter

- (NSString *)name {
  return FILTER_TONE_SHIFT_PLUS;
}

- (NSString *)previewImage {
  return FILTER_TONE_SHIFT_PLUS_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageHueFilter *filter = [GPUImageHueFilter new];
  filter.hue = 15.0;

  return [filter imageByFilteringImage:image];
}

@end
