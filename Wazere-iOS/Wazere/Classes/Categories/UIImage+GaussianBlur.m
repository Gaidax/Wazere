//
//  UIImage.m
//  Wazere
//
//  Created by Petr Yanenko on 10/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "UIImage+GaussianBlur.h"

@implementation UIImage (GaussianBlur)

- (UIImage *)imageWithBlurredCircleWithCenter:(CGPoint)center
                                       radius:(CGFloat)circleRadius
                                         blur:(CGFloat)blurRadius
                                   luminosity:(CGFloat)luminosity {
  UIImage *blurredImage = [self imageWithBlur:blurRadius luminosity:luminosity];
  CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);

  UIGraphicsBeginImageContext(self.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  // if you don't want to include the original image, exclude the next five
  // lines

  CGContextSaveGState(context);
  CGContextTranslateCTM(context, 0.0f, self.size.height);
  CGContextScaleCTM(context, 1.0f, -1.0f);
  CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
  CGContextRestoreGState(context);

  // clip the drawing to the blurred circle

  CGContextSaveGState(context);
  CGContextAddArc(context, center.x, center.y, circleRadius, 0, M_PI * 2.0, YES);
  CGContextClosePath(context);
  CGContextClip(context);
  CGContextTranslateCTM(context, 0.0f, self.size.height);
  CGContextScaleCTM(context, 1.0f, -1.0f);
  CGContextDrawImage(context, frame, blurredImage.CGImage);
  CGContextRestoreGState(context);

  // now save the image

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

- (UIImage *)imageWithBlur:(CGFloat)radius luminosity:(CGFloat)luminosity {
  CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];  // self.CIImage;
  CIContext *context = [CIContext contextWithOptions:nil];

  CIImage *blurImage = [self blurCIImage:inputImage radius:radius];
  CIImage *outputImage = [self changeLuminosityOfCIImage:blurImage luminosity:luminosity];

  // note, adjust rect because blur changed size of image

  CGRect rect = [outputImage extent];
  rect.origin.x += (rect.size.width - self.size.width) / 2;
  rect.origin.y += (rect.size.height - self.size.height) / 2;
  rect.size = self.size;

  CGImageRef cgimg = [context createCGImage:outputImage fromRect:rect];
  UIImage *image = [UIImage imageWithCGImage:cgimg];

  CGImageRelease(cgimg);

  return image;
}

- (CIImage *)blurCIImage:(CIImage *)inputImage radius:(CGFloat)radius {
  if (radius == 0) return inputImage;

  CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
  [blurFilter setDefaults];
  [blurFilter setValue:inputImage forKey:kCIInputImageKey];
  [blurFilter setValue:@(radius) forKey:kCIInputRadiusKey];

  return [blurFilter outputImage];
}

- (CIImage *)changeLuminosityOfCIImage:(CIImage *)inputImage luminosity:(CGFloat)luminosity {
  if (luminosity == 0) return inputImage;

  NSParameterAssert(luminosity >= -1.0 && luminosity <= 1.0);

  CIFilter *toneCurveFilter = [CIFilter filterWithName:@"CIToneCurve"];
  [toneCurveFilter setDefaults];
  [toneCurveFilter setValue:inputImage forKey:kCIInputImageKey];

  if (luminosity > 0) {
    [toneCurveFilter setValue:[CIVector vectorWithX:0.0 Y:luminosity] forKey:@"inputPoint0"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.25 Y:luminosity + 0.25 * (1 - luminosity)]
                       forKey:@"inputPoint1"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.50 Y:luminosity + 0.50 * (1 - luminosity)]
                       forKey:@"inputPoint2"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.75 Y:luminosity + 0.75 * (1 - luminosity)]
                       forKey:@"inputPoint3"];
    [toneCurveFilter setValue:[CIVector vectorWithX:1.0 Y:1.0] forKey:@"inputPoint4"];
  } else {
    [toneCurveFilter setValue:[CIVector vectorWithX:0.0 Y:0.0] forKey:@"inputPoint0"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.25 Y:0.25 * (1 + luminosity)]
                       forKey:@"inputPoint1"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.50 Y:0.50 * (1 + luminosity)]
                       forKey:@"inputPoint2"];
    [toneCurveFilter setValue:[CIVector vectorWithX:0.75 Y:0.75 * (1 + luminosity)]
                       forKey:@"inputPoint3"];
    [toneCurveFilter setValue:[CIVector vectorWithX:1.0 Y:1 + luminosity] forKey:@"inputPoint4"];
  }

  return [toneCurveFilter outputImage];
}

@end
