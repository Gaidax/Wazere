//
//  ASAmatorkaFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASAmatorkaFilter.h"

@implementation ASAmatorkaFilter

- (NSString *)name {
  return FILTER_AMATORKA;
}

- (NSString *)previewImage {
  return FILTER_AMATORKA_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  GPUImageAmatorkaFilter *filter = [GPUImageAmatorkaFilter new];

  return [filter imageByFilteringImage:image];
}

@end
