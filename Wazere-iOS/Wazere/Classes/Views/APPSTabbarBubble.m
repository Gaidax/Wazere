//
//  APPSTabbarBubble.m
//  Wazere
//
//  Created by Gaidax on 11/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSTabbarBubble.h"

@interface APPSTabbarBubble ()
@property(strong, nonatomic) NSArray *bubbleNames;
@end

@implementation APPSTabbarBubble
static CGFloat const viewTopOffset = 6.f;

- (instancetype)initWithXPosition:(CGFloat)xPosition {
  CGRect frame =
      CGRectMake(xPosition, -(imageSideSize - 2*viewTopOffset), imageSideSize, imageSideSize);
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    [self initializeImageView];
  }
  return self;
}

- (void)initializeImageView {
  self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
  self.imageView.image = [self imageForCurrentStyle];
  self.imageView.alpha = 0.f;
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self addSubview:self.imageView];
}

- (NSArray *)bubbleNames {
  return @[ @"like", @"follow", @"comment", @"photo" ];
}

- (UIImage *)imageForCurrentStyle {
  NSString *bubbleName = self.bubbleNames[self.bubbleStyle];
  return [UIImage imageNamed:[NSString stringWithFormat:@"bubble_%@", bubbleName]];
}

- (void)setBubbleStyle:(APPSTabbarBubbleStyle)bubbleStyle {
  _bubbleStyle = bubbleStyle;
  self.imageView.image = [self imageForCurrentStyle];
}

- (void)showBubbleWithStyle:(NSString *)style {
    self.bubbleStyle = [self styleFromString:style];
    [self animatePushReceived];
}

- (APPSTabbarBubbleStyle)styleFromString:(NSString *)string {
  if ([string isEqualToString:@"like"]) {
    return APPSTabbarBubbleStyleLike;
  }
  if ([string isEqualToString:@"comments"]) {
    return APPSTabbarBubbleStyleComment;
  }
  if ([string isEqualToString:@"photo"]) {
    return APPSTabbarBubbleStylePhoto;
  }
  return APPSTabbarBubbleStyleFollow;
}

- (void)animatePushReceived {
  NSTimeInterval duration = 0.3;
  [UIView animateWithDuration:duration
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                       self.imageView.alpha = 1.f;
                       CGRect f = self.imageView.frame;
                       f.origin.y -= 15.f;
                       f.size.width += 5.f;
                       f.size.height += 5.f;
                       self.imageView.frame = f;
                   }
                   completion:nil];

  [UIView animateWithDuration:duration
                        delay:duration
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                       CGRect f = self.imageView.frame;
                       f.origin.y += 15.f;
                       f.size.width -= 5.f;
                       f.size.height -= 5.f;
                       self.imageView.frame = f;
                   }
                   completion:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
