//
//  ASCommandCollectionViewDataSource.h
//  flocknest
//
//  Created by austinate on 20.05.14.
//  Copyright (c) 2014 Applikey Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyDataSource.h"

@class APPSStrategyCollectionViewController;

@protocol APPSStrategyCollectionViewDataSource<UICollectionViewDataSource, APPSStrategyDataSource>

@property(weak, NS_NONATOMIC_IOSONLY) APPSStrategyCollectionViewController *parentController;

- (void)reloadCollectionViewController:
        (APPSStrategyCollectionViewController __weak *)parentController;

@end
