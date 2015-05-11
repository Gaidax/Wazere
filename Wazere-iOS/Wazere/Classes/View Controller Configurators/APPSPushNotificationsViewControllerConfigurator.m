//
//  APPSPushNotificationsViewControllerConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPushNotificationsViewControllerConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSettingsConstants.h"

@implementation APPSPushNotificationsViewControllerConfigurator

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  return self;
}

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  UINib *nib = [UINib nibWithNibName:@"APPSSettingTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kPushNotificationsTableViewCell];
  ;
  controller.tableView.tableFooterView = [[UIView alloc] init];
}

@end
