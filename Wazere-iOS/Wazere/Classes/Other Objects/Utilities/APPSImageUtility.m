//
//  APPSImageUtility.m
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSImageUtility.h"
#import "APPSPhotoImageView.h"

@implementation APPSImageUtility

- (UIImage *)imageNamed:(NSString *)name {
  UIImage *image = [UIImage imageNamed:name];
  if (image == nil) {
    NSLog(@"%@",
          [NSError errorWithDomain:@"APPSImageUtility"
                              code:0
                          userInfo:@{
                            NSLocalizedFailureReasonErrorKey :
                                [NSString stringWithFormat:@"Image named %@ not loaded", name]
                          }]);
  }
  return image;
}

- (void)createBlurredPhotoWithTagline:(NSString *)tagline
                             imageURL:(NSURL *)url
                           completion:(void (^)(UIImage *image, NSError *error))handler {
  [self downloadImageWithURL:url
                  completion:^(UIImage *image, NSError *error) {
                      if (image) {
                        image = [self createBlurredPhotoWithTagline:tagline image:image error:&error];
                      }
                      if (handler) {
                        handler(image, error);
                      }
                  }];
}

- (void)downloadImageWithURL:(NSURL *)URL
                  completion:(void (^)(UIImage *image, NSError *error))handler {
  [[SDWebImageManager sharedManager]
      downloadImageWithURL:URL
                   options:0
                  progress:NULL
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                             BOOL finished, NSURL *imageURL) {
                     if (image || finished) {
                       if (finished && !image) {
                         NSLog(@"%@", error);
                       }
                       if (handler) {
                         handler(image, error);
                       }
                     }
                 }];
}

- (UIImage *)createBlurredPhotoWithTagline:(NSString *)tagline
                                     image:(UIImage *)image
                                     error:(NSError **)error {
  if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
    if (error) {
      *error = [NSError errorWithDomain:@"APPsImageUtility"
                                   code:2
                               userInfo:@{
                                 NSLocalizedFailureReasonErrorKey : @"Application in background"
                               }];
    }
    return nil;
  }
  APPSPhotoImageView *photoImagerView =
      [[APPSPhotoImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];

  photoImagerView.shouldBlur = NO;
  [photoImagerView createNotAviableLabel];
  photoImagerView.notAvailableLabel.text = tagline;
  photoImagerView.image = [photoImagerView createBlurredImage:image];

  UIGraphicsBeginImageContextWithOptions(photoImagerView.bounds.size, YES, 0.0);
  [photoImagerView.image drawInRect:photoImagerView.frame];
  [photoImagerView.notAvailableLabel drawTextInRect:photoImagerView.notAvailableLabel.frame];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end
