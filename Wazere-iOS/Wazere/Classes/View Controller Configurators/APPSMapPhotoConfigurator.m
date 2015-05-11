//
//  APPSMapPhotoConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapPhotoConfigurator.h"
#import "APPSProfileViewController.h"
#import "APPSSegmentSuplementaryView.h"
#import "APPSMapPhotoCollectionViewLayout.h"

@implementation APPSMapPhotoConfigurator

- (void)configureViewController:(APPSProfileViewController *)controller {
  [super configureViewController:controller];
  controller.collectionView.collectionViewLayout = [[APPSMapPhotoCollectionViewLayout alloc] init];

  [controller.navigationItem setTitle:NSLocalizedString(@"Photos Near You", nil)];
  controller.disposeLeftButton = YES;
  controller.navigationItem.rightBarButtonItems = nil;
}

- (void)registerSuplementaryViewClasses {
  [self.viewController.collectionView registerClass:[APPSSegmentSuplementaryView class]
                         forSupplementaryViewOfKind:kCollectionReusableView
                                withReuseIdentifier:kCollectionReusableView];
}

@end
