//
//  APPSSpinnerView.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSpinnerView.h"

@interface APPSSpinnerView ()

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(strong, nonatomic) NSArray *animatedImages;
@property(weak, nonatomic) UIView *superView;

@end

@implementation APPSSpinnerView

- (instancetype)init {
  self = [super init];
  if (self) {
    NSArray *subviewArray =
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([APPSSpinnerView class]) owner:self options:nil];
    APPSSpinnerView *view = subviewArray[0];
    self = view;

    self.animatedImages = @[];
    NSMutableArray *images = [NSMutableArray array];
    NSUInteger imagesCount = 16;
    for (unsigned long i = 1; i <= imagesCount; i++) {
      NSString *imageName = [NSString stringWithFormat:@"%lu-s", i];
      [images addObject:IMAGE_WITH_NAME(imageName)];
    }
    self.animatedImages = images;
  }
  return self;
}

- (instancetype)initWithSuperview:(UIView *)superview {
  self = [self init];
  if (self) {
    _superView = superview;
  }
  return self;
}

- (void)startAnimating {
  if (!self.superView) {
    self.superView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
  }

  self.imageView.animationImages = self.animatedImages;
  self.imageView.animationDuration = 2.0;
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.superView addSubview:self];
  [self.superView bringSubviewToFront:self];

  [self.superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{
                                                                             @"view" : self
                                                                           }]];
  [self.superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{
                                                                             @"view" : self
                                                                           }]];

  [self.imageView startAnimating];
}

- (void)stopAnimating {
  [self.imageView stopAnimating];
  [self removeFromSuperview];
}

@end
