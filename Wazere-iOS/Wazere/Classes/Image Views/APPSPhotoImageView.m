//
//  APPSBlurredImageView.m
//  Wazere
//
//  Created by Gaidax on 11/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotoImageView.h"

@interface APPSPhotoImageView ()

@property(strong, atomic) UIImage *blurredImage;
@property(assign, atomic) BOOL inBackground;

@property(weak, nonatomic) id<NSObject> willResignActiveObserver;
@property(weak, nonatomic) id<NSObject> didBecomeActiveObserver;

@end

@implementation APPSPhotoImageView

static const NSInteger activityIndicatorTag = 1;
static const NSInteger labelTag = 3;
static const CGFloat imageViewDefaultSize = 60.f;
static const CGFloat imageBlurCoeficient = 0.00025f;
static const CGFloat smallImageBlurCoeficient = 0.0015f;

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self.didBecomeActiveObserver];
  [[NSNotificationCenter defaultCenter] removeObserver:self.willResignActiveObserver];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  [self initProperties];
  [self initializeNotifications];
}

- (void)initializeNotifications {
  @weakify(self);
  self.willResignActiveObserver = [[NSNotificationCenter defaultCenter]
      addObserverForName:UIApplicationWillResignActiveNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *note) {
                @strongify(self);
                self.inBackground = YES;
              }];
  self.didBecomeActiveObserver = [[NSNotificationCenter defaultCenter]
      addObserverForName:UIApplicationDidBecomeActiveNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *note) {
                @strongify(self);
                self.inBackground = NO;
                if (self.blurredImage) {
                  [self startBlurringForImage:self.blurredImage];
                }
              }];
}

- (void)initProperties {
  _inBackground = [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive;
}

- (UIActivityIndicatorView *)activityIndicator {
  UIActivityIndicatorView *view =
      (UIActivityIndicatorView *)[self viewWithTag:activityIndicatorTag];
  if (!view) {
    view = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.hidesWhenStopped = YES;
    view.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);

    view.tag = activityIndicatorTag;
    [self addSubview:view];
  }
  return view;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
  [self viewWithTag:labelTag].center = center;
  [self viewWithTag:activityIndicatorTag].center = center;
}

- (UIImage *)createBlurredImage:(UIImage *)image {
  CGFloat width = CGRectGetWidth(self.bounds);
  CGFloat height = CGRectGetHeight(self.bounds);
  CGFloat blurRadius =
      (width >= imageViewDefaultSize ? imageBlurCoeficient : smallImageBlurCoeficient) *
      (width * height);

  GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
  blurFilter.blurRadiusInPixels = blurRadius;
  blurFilter.shouldSmoothlyScaleOutput = YES;
  UIImage *blockImage = [blurFilter imageByFilteringImage:image];
  return blockImage;
}

- (void)setupBlurredImage:(UIImage *)image {
  UIImage *blockImage = [self createBlurredImage:image];
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.blurredImage != image) {
      return;
    }
    self.blurredImage = nil;
    [super setImage:blockImage];

    if (self.blurCompetionBlock) {
      [self setNeedsLayout];
      [self layoutSubviews];
      self.blurCompetionBlock();
    }
  });
}

- (void)startBlurringForImage:(UIImage *)image {
  dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  dispatch_async(myQueue, ^{
    if (self.blurredImage != image || self.inBackground) {
      return;
    }
    [self setupBlurredImage:image];
  });
}

- (void)setImage:(UIImage *)image {
  self.blurredImage = nil;
  if (self.shouldBlur && image) {
    self.blurredImage = image;
    [self startBlurringForImage:image];
  } else {
    [super setImage:image];
  }
}

- (UILabel *)notAvailableLabel {
  return (UILabel *)[self viewWithTag:labelTag];
}

- (void)createNotAviableLabel {
  if (!self.notAvailableLabel) {
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);

    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor colorWithRed:0.447 green:0.078 blue:0.020 alpha:1.000];
    NSInteger fontSize = CGRectGetHeight(self.frame) > imageViewDefaultSize ? 17.f : 10.f;
    label.font = FONT_HELVETICANEUE_LIGHT(fontSize);
    label.tag = labelTag;
    label.numberOfLines = 0;

    [self addSubview:label];
  }
}

- (void)setShouldBlur:(BOOL)shouldBlur {
  if (shouldBlur) {
    [self createNotAviableLabel];
  } else {
    [[self viewWithTag:labelTag] removeFromSuperview];
  }
  _shouldBlur = shouldBlur;
}

#pragma mark - Photo Uploading helpers

- (UIImage *)blurredImageWithTagline {
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);

  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return image;
}

@end
