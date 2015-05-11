//
//  APPSResizableLabel.m
//  Wazere
//
//  Created by Petr Yanenko on 11/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSResizableLabel.h"

@implementation APPSResizableLabel

- (CGSize)intrinsicContentSize {
  CGSize size = self.bounds.size;
  
  return [self intrinsicContentSizeWithSize:size];
}

- (CGSize)intrinsicContentSizeWithSize:(CGSize)size {
  NSAttributedString *string = self.attributedText;
  if (string.length) {
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                           options:(NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingTruncatesLastVisibleLine)
                                           context:nil];
    size.height = ceil(textRect.size.height) +
    (self.offset ? self.offset : kResizableLabelDefaultOffset) * 2.0;
    size.width = ceil(textRect.size.width);
  } else {
    size = CGSizeZero;
  }
  return size;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
  CGSize textSize = [self intrinsicContentSize];
  CGRect textRect = CGRectMake(0, 0, textSize.width, textSize.height);
  if (self.textAlignment == NSTextAlignmentCenter) {
    textRect.origin.x = (CGRectGetWidth(self.bounds) - textRect.size.width) / 2;
  }
  if (self.textAlignment == NSTextAlignmentRight) {
    textRect.origin.x = CGRectGetWidth(self.bounds) - textRect.size.width;
  }
  return textRect;
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [self intrinsicContentSizeWithSize:size];
}

@end
