//
//  APPSSharePhotoTextField.m
//  Wazere
//
//  Created by iOS Developer on 9/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoTextField.h"

@implementation APPSSharePhotoTextField

static CGFloat const rightImageOffset = 5;
static CGFloat const imageSideSize = 15;
static CGFloat const textLeftInset = 9;

- (CGRect)textRectForBounds:(CGRect)bounds {
  return
      [super textRectForBounds:UIEdgeInsetsInsetRect(
                                   bounds, UIEdgeInsetsMake(0, textLeftInset, 0,
                                                            CGRectGetWidth(self.leftView.frame)))];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [super
      editingRectForBounds:UIEdgeInsetsInsetRect(
                               bounds, UIEdgeInsetsMake(0, textLeftInset, 0,
                                                        CGRectGetWidth(self.leftView.frame)))];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
  CGRect leftViewFrame = [super
      rightViewRectForBounds:UIEdgeInsetsInsetRect(
                                 bounds, UIEdgeInsetsMake(0, textLeftInset, 0, rightImageOffset))];
  leftViewFrame.origin.x -= rightImageOffset;
  return leftViewFrame;
}

- (void)configureTextFiledwithLeftImageName:(NSString *)rightImageName {
  if (rightImageName) {
    UIImage *leftImage = [UIImage imageNamed:rightImageName];
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:leftImage];
    leftIcon.frame = CGRectMake(0, 0, imageSideSize, imageSideSize);
    leftIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.rightView = leftIcon;
    self.rightViewMode = UITextFieldViewModeAlways;
  }
}

@end
