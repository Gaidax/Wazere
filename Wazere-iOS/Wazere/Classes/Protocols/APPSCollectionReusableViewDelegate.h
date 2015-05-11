//
//  APPSCollectionReusableViewDelegate.h
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

@protocol APPSCollectionReusableViewDelegate<NSObject>
@optional
- (void)collectionReusableView:(UICollectionReusableView *)view gridAction:(UIButton *)sender;
- (void)collectionReusableView:(UICollectionReusableView *)view listAction:(UIButton *)sender;

@end
