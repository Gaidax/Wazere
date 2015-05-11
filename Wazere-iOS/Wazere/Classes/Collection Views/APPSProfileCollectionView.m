//
//  APPSProfileCollectionView.m
//  Wazere
//
//  Created by Petr Yanenko on 1/9/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSProfileCollectionView.h"

@implementation APPSProfileCollectionView

- (void)reloadData {
  [super reloadData];
  dispatch_async(dispatch_get_main_queue(), ^{
      UIView* background = [self viewWithTag:kBackgroundViewTag];
      [self sendSubviewToBack:background];
  });
}

@end
