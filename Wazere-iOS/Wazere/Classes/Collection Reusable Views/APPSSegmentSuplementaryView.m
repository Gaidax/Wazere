//
//  APPSSegmentSuplementaryView.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSegmentSuplementaryView.h"

@implementation APPSSegmentSuplementaryView

static NSInteger const segmentControlLeftShift = 5.f;

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    self.clipsToBounds = YES;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self updateSegmentControlFrame];
}

- (void)layoutMarginsDidChange {
}

- (void)setDelegate:(id<APPSSegmentSuplementaryViewDelegate>)delegate {
  _delegate = delegate;

  [UIView setAnimationsEnabled:NO];

  if (self.segmentControl == nil) {
    [self createSegmentControl];
  }

  [UIView setAnimationsEnabled:YES];
}

- (void)createSegmentControl {
  if ([self.delegate respondsToSelector:@selector(suplementaryViewButtonItems)]) {
    self.segmentControl =
        [[UISegmentedControl alloc] initWithItems:[_delegate suplementaryViewButtonItems]];
    self.segmentControl.tintColor = kMainBackgroundColor;

    [self updateSegmentControlFrame];

    [self.segmentControl addTarget:self
                            action:@selector(segmentControlValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentControl];
  }
}

- (void)updateSegmentControlFrame {
  CGRect frame = self.segmentControl.frame;
  frame.size.width = CGRectGetWidth(self.frame) - 2 * segmentControlLeftShift;
  frame.origin.x = segmentControlLeftShift;
  frame.origin.y = CGRectGetHeight(self.frame) / 2 - CGRectGetHeight(frame) / 2;
  [self.segmentControl setFrame:frame];
}

- (void)segmentControlValueChanged:(UISegmentedControl *)segmentControl {
  if ([self.delegate respondsToSelector:@selector(suplementaryView:valueChanged:)]) {
    [self.delegate suplementaryView:self valueChanged:segmentControl];
  }

  if ([self.delegate respondsToSelector:@selector(collectionReusableView:gridAction:)]) {
    segmentControl.selectedSegmentIndex
        ? [self.delegate collectionReusableView:self listAction:nil]
        : [self.delegate collectionReusableView:self gridAction:nil];
  }
}

@end