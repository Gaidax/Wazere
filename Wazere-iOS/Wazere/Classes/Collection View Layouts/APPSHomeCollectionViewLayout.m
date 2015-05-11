//
//  APPSHomeCollectionViewLayout.m
//  Wazere
//
//  Created by Gaidax on 10/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHomeCollectionViewLayout.h"
#import "APPSTabBarViewController.h"
#import "APPSNavigationViewController.h"

#define kCellWidth SCREEN_WIDTH
static CGFloat const kMinCellHeight = 370;

@implementation APPSHomeCollectionViewLayout

- (CGFloat)headerHeight {
    return 0;
}

- (CGFloat)minimumCellHeight {
    return kMinCellHeight;
}

@end
