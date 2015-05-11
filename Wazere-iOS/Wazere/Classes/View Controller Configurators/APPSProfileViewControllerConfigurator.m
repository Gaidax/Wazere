//
//  APPSProfileViewControllerConfigurator.m
//  Wazere
//
//  Created by Bogdan Bilonog on 10/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileViewControllerConfigurator.h"

#import "APPSProfileViewController.h"

#import "APPSProfileViewControllerDelegate.h"

#import "APPSGridCell.h"

#import "APPSProfileRightButtonStrategyProtocol.h"

@implementation APPSProfileViewControllerConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSProfileViewController *)controller {
  self.viewController = controller;
  [self addBackgroundOnCollectionView];
  [self configurNavigationBar];
  [self registerClasses];
}

- (void)addBackgroundOnCollectionView {
  UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  backgroundView.backgroundColor = UIColorFromRGB(239, 239, 239, 1.0);
  backgroundView.tag = kBackgroundViewTag;
  [self.viewController.collectionView addSubview:backgroundView];
  [self.viewController.collectionView sendSubviewToBack:backgroundView];
}

#pragma mark - configurNavigationBar

- (void)configurNavigationBar {
  NSMutableDictionary *attributes =
      [NSMutableDictionary dictionaryWithDictionary:[self.viewController.navigationController
                                                            .navigationBar titleTextAttributes]];
  [attributes setValue:FONT_CHAMPAGNE_LIMOUSINES_BOLD(20) forKey:NSFontAttributeName];
  [attributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
  [self.viewController.navigationController.navigationBar setTitleTextAttributes:attributes];
  UIViewController *navigationRootController =
      [self.viewController.navigationController.viewControllers firstObject];
  self.viewController.disposeLeftButton =
      navigationRootController && navigationRootController != self.viewController;
  APPSProfileViewControllerDelegate *delegate =
      (APPSProfileViewControllerDelegate *)self.viewController.delegate;
  NSString *settingsImageName = @"settings", *blockUserImageName = @"mark_as_inappropriate_button";

  UIImage *rightBarButtonImage = [[[APPSUtilityFactory sharedInstance] imageUtility]
      imageNamed:[delegate isCurrentUser] ? settingsImageName : blockUserImageName];
  UIBarButtonItem *rightBarButton =
      [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage
                                       style:UIBarButtonItemStyleBordered
                                      target:delegate.rightNavigationButtonStrategy
                                      action:@selector(rightNavigationButtonAction:)];
  self.viewController.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - addRefreshControl
// Set selector in delegate
- (void)addRefreshControl {
  self.viewController.refreshControl = [[UIRefreshControl alloc] init];
  self.viewController.refreshControl.tintColor = [UIColor whiteColor];
  [self.viewController.refreshControl addTarget:self.viewController
                                         action:@selector(refresh:)
                               forControlEvents:UIControlEventValueChanged];
  [self.viewController.collectionView addSubview:self.viewController.refreshControl];
}

#pragma mark - registerClasses

- (void)registerCellClasses {
  [self.viewController.collectionView
                     registerNib:[UINib nibWithNibName:kRectCollectionViewCell bundle:nil]
      forCellWithReuseIdentifier:kRectCollectionViewCell];

  [self.viewController.collectionView registerClass:[APPSGridCell class]
                         forCellWithReuseIdentifier:kGridCollectionViewCell];

  [self.viewController.collectionView
                     registerNib:[UINib nibWithNibName:kLoadingCollectionViewCell bundle:nil]
      forCellWithReuseIdentifier:kLoadingCollectionViewCell];
}

- (void)registerSuplementaryViewClasses {
  [self.viewController.collectionView
                     registerNib:[UINib nibWithNibName:kCollectionReusableView bundle:nil]
      forSupplementaryViewOfKind:kCollectionReusableView
             withReuseIdentifier:kCollectionReusableView];
}

- (void)registerClasses {
  [self registerCellClasses];
  [self registerSuplementaryViewClasses];
}

@end
