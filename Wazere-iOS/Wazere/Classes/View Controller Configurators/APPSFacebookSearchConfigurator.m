//
//  APPSFacebookSearchConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFacebookSearchConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSearchConstants.h"

@implementation APPSFacebookSearchConfigurator

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
  UINib *nib = [UINib nibWithNibName:@"APPSFollowAllHeaderView" bundle:nil];
  [controller.tableView registerNib:nib
      forHeaderFooterViewReuseIdentifier:kFacebookSearchTableViewHeader];
  controller.tableView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
}

@end
