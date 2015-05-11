//
//  ASNormalFilter.m
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import "ASNormalFilter.h"

@implementation ASNormalFilter

- (NSString *)name {
  return FILTER_NORMAL;
}

- (NSString *)previewImage {
  return FILTER_NORMAL_IMAGE;
}

- (UIImage *)filteredImage:(UIImage *)image {
  return image;
}

@end
