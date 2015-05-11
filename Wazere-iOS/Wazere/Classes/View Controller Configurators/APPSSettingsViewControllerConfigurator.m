//
//  APPSSettingsViewControllerConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSettingsViewControllerConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSettingsConstants.h"

@implementation APPSSettingsViewControllerConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  [controller.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:kSettingsViewCell];
  controller.tableView.tableFooterView = [[UIView alloc] init];
  controller.tableView.clipsToBounds = YES;
  controller.tableView.showsHorizontalScrollIndicator = NO;
  controller.tableView.showsVerticalScrollIndicator = NO;
  [controller.refreshControl removeFromSuperview];
}

@end
