//
//  APPSEditProfileViewControllerConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSEditProfileViewControllerConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSEditProfileViewControllerDelegate.h"

@implementation APPSEditProfileViewControllerConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  UINib *nib = [UINib nibWithNibName:@"APPSEditPhotoTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kEditPhotoTableViewCell];
  nib = [UINib nibWithNibName:@"APPSEditTextTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kFollowListTableViewCell];

  controller.tableView.tableFooterView = [[UIView alloc] init];
  controller.tableView.allowsSelection = YES;

  [self configureNavigationBarButtons:controller];
}

- (void)configureNavigationBarButtons:(APPSStrategyTableViewController *)targetController {
  UIBarButtonItem *doneBarButton =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                    target:targetController.delegate
                                                    action:@selector(handleDonePressed)];
  doneBarButton.tintColor = [UIColor whiteColor];
  targetController.navigationItem.rightBarButtonItem = doneBarButton;
}

@end
