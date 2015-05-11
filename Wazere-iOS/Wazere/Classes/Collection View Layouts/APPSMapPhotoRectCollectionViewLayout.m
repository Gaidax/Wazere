//
//  APPSMapPhotoCollectionViewLayout.m
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapPhotoRectCollectionViewLayout.h"

@implementation APPSMapPhotoRectCollectionViewLayout

- (void)setupHeaderSize {
  self.headerRect = CGRectMake(0.f, 0.f, SCREEN_WIDTH, kMapPhotoCollectionHeaderViewHeight);
}

@end
