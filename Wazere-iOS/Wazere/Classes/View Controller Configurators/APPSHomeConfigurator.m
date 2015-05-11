//
//  APPSHomeConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 10/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHomeConfigurator.h"
#import "APPSProfileViewController.h"
#import "APPSSegmentSuplementaryView.h"

#import "APPSHomeCollectionViewLayout.h"
#import "APPSHomeDelegate.h"

@implementation APPSHomeConfigurator
static CGFloat const APPSSegmentViewWidth = 205;

- (void)configureViewController:(APPSProfileViewController *)controller {
  [super configureViewController:controller];
  [self configureRightButtonForController:controller];
  [self configureHeaderSegmentControlForController:controller];
  controller.collectionView.collectionViewLayout = [[APPSHomeCollectionViewLayout alloc] init];
  controller.disposeLeftButton = NO;
}

- (void)configureHeaderSegmentControlForController:(APPSProfileViewController *)controller {
    CGRect segmentFrame = controller.navigationController.navigationBar.bounds;
    segmentFrame.size.width = APPSSegmentViewWidth;
    APPSSegmentSuplementaryView *segmentView = [[APPSSegmentSuplementaryView alloc]
                                                initWithFrame:segmentFrame];
    segmentView.backgroundColor = [UIColor clearColor];
    segmentView.delegate = (id<APPSSegmentSuplementaryViewDelegate>) controller.delegate;
    segmentView.segmentControl.tintColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    segmentView.segmentControl.selectedSegmentIndex = 0;
    controller.navigationItem.titleView = segmentView;
}

- (void)configureRightButtonForController:(APPSProfileViewController *) controller {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list_view"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:controller.delegate
                                                                      action:@selector(changeLayoutButtonPressed:)];
    controller.navigationItem.rightBarButtonItem = rightBarButton;
}

@end
