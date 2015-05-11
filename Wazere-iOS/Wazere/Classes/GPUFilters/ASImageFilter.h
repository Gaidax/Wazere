//
//  ASImageFilter.h
//  pensapet
//
//  Created by User on 28.01.14.
//  Copyright (c) 2014 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASFilters.h"
#import "ASFiltersImages.h"

@interface ASImageFilter : NSObject

@property(nonatomic, readonly) NSString *previewImage;
@property(nonatomic, readonly) NSString *name;

- (UIImage *)filteredImage:(UIImage *)image;

@end
