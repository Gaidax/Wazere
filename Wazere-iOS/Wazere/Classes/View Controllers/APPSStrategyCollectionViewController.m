//
//  ASCommandCollectionViewController.m
//  flocknest
//
//  Created by austinate on 20.05.14.
//  Copyright (c) 2014 Applikey Solutions. All rights reserved.
//

#import "APPSStrategyCollectionViewController.h"
#import "APPSStrategyCollectionViewDataSource.h"
#import "APPSStrategyCollectionViewDelegate.h"

@interface APPSStrategyCollectionViewController ()

@end

@implementation APPSStrategyCollectionViewController

#pragma mark UICollectionViewController life-cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.tintColor = [UIColor whiteColor];
  [self.refreshControl addTarget:self
                          action:@selector(refresh:)
                forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:self.refreshControl];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadCollectionView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)refreshControl {
  [self reloadCollectionView];
  [refreshControl endRefreshing];
}

- (void)reloadCollectionView {
  if (!self.disableReload) {
    [self.dataSource reloadCollectionViewController:self];
  }
  self.disableReload = NO;
}

#pragma mark UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [self.dataSource collectionView:collectionView numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  if (self.dataSource != (id<APPSStrategyCollectionViewDataSource>)self &&
      [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
    return [self.dataSource numberOfSectionsInCollectionView:collectionView];
  }
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  if (self.dataSource != (id<APPSStrategyCollectionViewDataSource>)self &&
      [self.dataSource respondsToSelector:@selector(collectionView:
                                              viewForSupplementaryElementOfKind:
                                                                    atIndexPath:)]) {
    return [self.dataSource collectionView:collectionView
         viewForSupplementaryElementOfKind:kind
                               atIndexPath:indexPath];
  }
  return nil;
}

#pragma mark UICollectionView Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView
    shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UICollectionViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
    return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
  }
  return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UICollectionViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
    [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
  }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [self.delegate scrollViewDidEndDecelerating:scrollView];
  }
}

@end
