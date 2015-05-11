//
//  ASCommandCollectionViewController.h
//  flocknest
//
//  Created by austinate on 20.05.14.
//  Copyright (c) 2014 Applikey Solutions. All rights reserved.
//

#import "APPSCollectionViewController.h"

@protocol APPSStrategyCollectionViewDataSource;
@protocol APPSStrategyCollectionViewDelegate;

@interface APPSStrategyCollectionViewController : APPSCollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, NS_NONATOMIC_IOSONLY) id<APPSStrategyCollectionViewDataSource> dataSource;
@property(strong, NS_NONATOMIC_IOSONLY) id<APPSStrategyCollectionViewDelegate> delegate;
@property(strong, NS_NONATOMIC_IOSONLY) UIRefreshControl *refreshControl;

@property(assign, NS_NONATOMIC_IOSONLY) BOOL openedModally;

@property(assign, NS_NONATOMIC_IOSONLY) BOOL disableReload;

- (void)reloadCollectionView;
- (void)refresh:(UIRefreshControl *)refreshControl;

@end
