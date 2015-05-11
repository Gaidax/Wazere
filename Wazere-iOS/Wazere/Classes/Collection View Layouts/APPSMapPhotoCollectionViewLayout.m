//
//  APPSMapPhotoCollectionViewLayout.m
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapPhotoCollectionViewLayout.h"
#import "APPSNavigationViewController.h"
#import "APPSTabBarViewController.h"


#define kCellWidth SCREEN_WIDTH
static CGFloat const kMinCellHeight = 370;

@implementation APPSMapPhotoCollectionViewLayout

- (CGFloat)headerHeight {
    return HomeReusbleHeaderHeight;
}

- (CGFloat)minimumCellHeight {
    return kMinCellHeight;
}

- (CGFloat)cellHeight {
    APPSTabBarViewController *rootViewController = [APPSTabBarViewController rootViewController];
    
    CGFloat barsHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) +
    CGRectGetHeight(((APPSNavigationViewController *) rootViewController.selectedViewController).navigationBar.frame);
    
    CGFloat freeSpaceHeight = SCREEN_HEIGHT - barsHeight - [self headerHeight];
    
    return MAX(freeSpaceHeight, [self minimumCellHeight]);
}


@end
