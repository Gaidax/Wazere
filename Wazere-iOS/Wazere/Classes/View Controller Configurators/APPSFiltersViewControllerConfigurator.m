//
//  APPSFilterViewControllerConfogurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFiltersViewControllerConfigurator.h"
#import "APPSStrategyTableViewController.h"

@implementation APPSFiltersViewControllerConfigurator

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  for (UIView *view in controller.view.subviews) {
    if ([view isKindOfClass:[UIImageView class]]) {
      [view removeFromSuperview];
    }
  }
  UINib *nib = [UINib nibWithNibName:@"APPSFiltersTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kHomeFiltersTableViewCellIdentifier];
  controller.tableView.tableFooterView = [[UIView alloc] init];
  controller.tableView.backgroundColor = [UIColor clearColor];
  controller.tableView.allowsSelection = YES;
  [controller.refreshControl removeFromSuperview];
}

@end
