//
//  APPSGridLayout.h
//  Wazere
//
//  Created by iOS Developer on 11/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSGridLayout : UICollectionViewLayout

@end

// protected
@interface APPSGridLayout ()

@property(strong, nonatomic) NSDictionary *layoutInfo;

@property(assign, nonatomic) UIEdgeInsets itemInsets;
@property(assign, nonatomic) CGSize itemSize;
@property(assign, nonatomic) CGFloat interItemSpacingY;
@property(assign, nonatomic) NSInteger numberOfColumns;
@property(assign, nonatomic) NSUInteger currentSection;
@property(assign, nonatomic) NSUInteger currentItem;
@property(assign, nonatomic) CGRect headerRect;

@end
