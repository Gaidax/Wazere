//
//  APPSSegmentSuplementaryView.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSCollectionReusableViewDelegate.h"

@class APPSSegmentSuplementaryView;

@protocol APPSSegmentSuplementaryViewDelegate<APPSCollectionReusableViewDelegate>

- (NSArray *)suplementaryViewButtonItems;
@optional
- (void)suplementaryView:(APPSSegmentSuplementaryView *)view
            valueChanged:(UISegmentedControl *)sender;
@end

@interface APPSSegmentSuplementaryView : UICollectionReusableView

@property(strong, NS_NONATOMIC_IOSONLY) UISegmentedControl *segmentControl;
@property(weak, NS_NONATOMIC_IOSONLY) id<APPSSegmentSuplementaryViewDelegate> delegate;
@end
