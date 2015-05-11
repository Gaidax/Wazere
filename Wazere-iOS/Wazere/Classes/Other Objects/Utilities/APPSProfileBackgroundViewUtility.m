//
//  APPS.m
//  Wazere
//
//  Created by Petr Yanenko on 1/30/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSProfileBackgroundViewUtility.h"

@implementation APPSProfileBackgroundViewUtility

- (CGRect)frameForBackgroundViewWithHeaderRect:(CGRect)headerRect
                             collectioViewRect:(CGRect)collectionViewFrame
                                 contentHeignt:(CGFloat)contentHeight {
  CGRect backgroundFrame =
      CGRectMake(0, CGRectGetMaxY(headerRect), CGRectGetWidth(collectionViewFrame),
                 contentHeight - CGRectGetMaxY(headerRect));
  CGFloat visibleContentHeight = CGRectGetHeight(collectionViewFrame) - CGRectGetHeight(headerRect);
  if (CGRectGetHeight(backgroundFrame) < visibleContentHeight) {
    backgroundFrame.size.height = visibleContentHeight;
  }
  return backgroundFrame;
}

@end
