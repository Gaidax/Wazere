//
//  APPSProfileCollectionViewLayout.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSProfileCollectionViewLayout : UICollectionViewLayout

@property(strong, nonatomic) NSDictionary *layoutInfo;

- (void)setup;
- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath;

@end

// protected
@interface APPSProfileCollectionViewLayout ()

@property(assign, nonatomic) UIEdgeInsets itemInsets;
@property(assign, nonatomic) CGSize itemSize;
@property(assign, nonatomic) CGRect headerRect;

- (CGFloat)cellHeight;
- (CGFloat)headerHeight;
- (CGFloat)minimumCellHeight;

@end
