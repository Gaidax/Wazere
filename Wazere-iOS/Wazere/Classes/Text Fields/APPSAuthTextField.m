//
//  APPSAuthTextField.m
//  Wazere
//
//  Created by iOS Developer on 9/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAuthTextField.h"

@implementation APPSAuthTextField

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = NO;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return [super textRectForBounds:UIEdgeInsetsInsetRect(
                                      bounds, UIEdgeInsetsMake(
                                                  0, -CGRectGetWidth(self.leftView.frame), 0, 0))];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return
      [super editingRectForBounds:UIEdgeInsetsInsetRect(
                                      bounds, UIEdgeInsetsMake(
                                                  0, -CGRectGetWidth(self.leftView.frame), 0, 0))];
}

@end
