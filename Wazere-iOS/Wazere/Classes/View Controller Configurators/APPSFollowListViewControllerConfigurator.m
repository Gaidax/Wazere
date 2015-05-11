//
//  APPSFollowListViewControllerConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFollowListViewControllerConfigurator.h"
#import "APPSStrategyTableViewController.h"

@implementation APPSFollowListViewControllerConfigurator
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  UINib *nib = [UINib nibWithNibName:@"APPSSearchResultTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kFollowListTableViewCell];
  nib = [UINib nibWithNibName:@"APPSLoadingTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kFollowListLoadingCellIdentifier];
  controller.tableView.tableFooterView = [[UIView alloc] init];
  controller.tableView.allowsSelection = YES;
}

@end
