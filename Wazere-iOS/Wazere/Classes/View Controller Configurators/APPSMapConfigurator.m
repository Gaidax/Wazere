//
//  APPSMapConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapConfigurator.h"
#import "APPSMapViewController.h"
#import "KPGridClusteringAlgorithm.h"
#import "APPSMapDelegate.h"

@implementation APPSMapConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSMapViewController *)controller {
  controller.filtersView.delegate = controller;
  [controller.searchBar removeFromSuperview];
  [self configureFiltersViewOnController:controller];

  KPGridClusteringAlgorithm *algorithm = [[KPGridClusteringAlgorithm alloc] init];
  CGFloat gridSize = 50, annotationWidth = 25, annotationHeight = 50;
  algorithm.gridSize = CGSizeMake(gridSize, gridSize);
  algorithm.annotationSize = CGSizeMake(annotationWidth, annotationHeight);
  algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategyTwoPhase;

  controller.clusteringController =
      [[KPClusteringController alloc] initWithMapView:controller.mapView
                                  clusteringAlgorithm:algorithm];
  controller.clusteringController.delegate = controller;

  controller.clusteringController.animationOptions = UIViewAnimationOptionCurveEaseOut;

  CGFloat buttonSize = 44.0;
  UIButton *rightNavigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
  rightNavigationButton.frame = CGRectMake(0, 0, buttonSize, buttonSize);
  rightNavigationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [rightNavigationButton
      setImage:[[[APPSUtilityFactory sharedInstance] imageUtility] imageNamed:@"binocular_icon"]
      forState:UIControlStateNormal];
  [rightNavigationButton setImage:[[[APPSUtilityFactory sharedInstance] imageUtility]
                                      imageNamed:@"binocular_icon_pressed"]
                         forState:UIControlStateHighlighted];
  [rightNavigationButton addTarget:controller.delegate
                            action:@selector(tapsRightNavigationButton:)
                  forControlEvents:UIControlEventTouchUpInside];
  rightNavigationButton.hidden = YES;

  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavigationButton];
  controller.navigationItem.rightBarButtonItems = @[ rightItem ];

  controller.title = NSLocalizedString(@"Nearby", nil);
  controller.navigationController.navigationBar.titleTextAttributes =
      @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)configureFiltersViewOnController:(APPSMapViewController *)controller {
  [controller mapFiltersView:controller.filtersView
                selectFilter:controller.filtersView.currentFilter
                  dateFilter:[controller.filtersView timeFilter]];
}

@end
