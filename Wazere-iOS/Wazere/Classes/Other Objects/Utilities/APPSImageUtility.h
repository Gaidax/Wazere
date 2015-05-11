//
//  APPSImageUtility.h
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSImageUtility : NSObject

- (UIImage *)imageNamed:(NSString *)name;
- (UIImage *)createBlurredPhotoWithTagline:(NSString *)tagline
                                     image:(UIImage *)image
                                     error:(NSError **)error;
- (void)createBlurredPhotoWithTagline:(NSString *)tagline
                             imageURL:(NSURL *)url
                           completion:(void (^)(UIImage *image, NSError *error))handler;
- (void)downloadImageWithURL:(NSURL *)URL
                  completion:(void (^)(UIImage *image, NSError *error))handler;

@end
