//
//  APPSNewsFeedViewControllerConfigurator.m
//  Wazere
//
//  Created by Gaidax on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNewsFeedViewControllerConfigurator.h"

#import "APPSStrategyTableViewController.h"
#import "APPSNewsFeedConstants.h"

@implementation APPSNewsFeedViewControllerConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  [super configureViewController:controller];
  UINib *nib = [UINib nibWithNibName:@"APPSNewsFeedTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kFeedTableViewCell];
    
    nib = [UINib nibWithNibName:@"APPSNewsFeedEmptyTableViewCell" bundle:nil];
    [controller.tableView registerNib:nib forCellReuseIdentifier:kFeedEmptyCell];

  controller.tableView.allowsSelection = NO;
  controller.disposeLeftButton = NO;
}

@end
