//
//  APPSResizableTextView.m
//  Wazere
//
//  Created by Gaidax on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSResizableTextView.h"

@implementation APPSResizableTextView

static CGFloat leftViewWidth = 20.f;
static CGFloat leftViewImageOffset = 5.f;

- (void)awakeFromNib {
  [super awakeFromNib];
  CGRect frame = self.frame;
  frame.origin = CGPointZero;
  frame.origin.x = leftViewImageOffset;
  frame.size.width = leftViewWidth;
  self.leftImageView = [[UIImageView alloc] initWithFrame:frame];
  self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;

  [self addSubview:self.leftImageView];

  self.scrollEnabled = NO;
    
  self.layer.borderWidth = 1.f;
  self.layer.borderColor = [[UIColor whiteColor] CGColor];

  UIEdgeInsets edgeInsets = self.textContainerInset;
  edgeInsets.left = (leftViewWidth + leftViewImageOffset);
  self.textContainerInset = edgeInsets;
}

- (CGSize)intrinsicContentSize {
  CGSize size = self.frame.size;
  size = [self sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)];
  return size;
}

@end
