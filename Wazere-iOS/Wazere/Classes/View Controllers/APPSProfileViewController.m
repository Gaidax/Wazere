//
//  APPSProfileViewController.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/9/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileCollectionView.h"

@interface APPSProfileViewController ()

@end

@implementation APPSProfileViewController

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  CGRect collectionViewFrame = self.collectionView.frame;
  CGPoint contentOffset = self.collectionView.contentOffset;
  CGSize contentSize = self.collectionView.contentSize;
  UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
  [self.collectionView removeFromSuperview];
  UICollectionView *collectionView =
      [[APPSProfileCollectionView alloc] initWithFrame:collectionViewFrame
                         collectionViewLayout:layout];
  collectionView.backgroundColor = [UIColor clearColor];
  collectionView.autoresizingMask =
      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
      UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
      UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  collectionView.alwaysBounceVertical = YES;
  [self.view addSubview:collectionView];
  [self.view sendSubviewToBack:collectionView];
  self.collectionView = collectionView;
  APPSProfileViewControllerConfigurator *configurator =
  (APPSProfileViewControllerConfigurator *)self.configurator;
  [configurator addBackgroundOnCollectionView];
  [configurator addRefreshControl];
  [configurator registerClasses];
  collectionView.contentOffset = contentOffset;
  collectionView.contentSize = contentSize;
  collectionView.delegate = self;
  collectionView.dataSource = self;
}

@end
