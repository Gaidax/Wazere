//
//  ASMissEticateFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASMissEticateFilter.h"

@implementation ASMissEticateFilter

- (NSString *)name {
  return FILTER_MISS_ETIKATE;
}

- (NSString *)previewImage {
  return FILTER_MISS_ETIKATE_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageMissEtikateFilter *filter = [GPUImageMissEtikateFilter new];

  return [filter imageByFilteringImage:image];
}

@end
