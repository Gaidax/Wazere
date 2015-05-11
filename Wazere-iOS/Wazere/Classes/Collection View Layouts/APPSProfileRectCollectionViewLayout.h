//
//  APPSProfileRectCollectionViewLayout.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileCollectionViewLayout.h"
#import <UIImageView+AFNetworking.h>

@protocol APPSProfileRectCollectionViewLayoutDelegate<NSObject>

- (NSMutableArray *)cellExtraHeights;

@end

@interface APPSProfileRectCollectionViewLayout : APPSProfileCollectionViewLayout

@property(weak, NS_NONATOMIC_IOSONLY) id<APPSProfileRectCollectionViewLayoutDelegate> delegate;

@end
