//
//  APPSSearchViewControllerConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSearchViewControllerConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSearchConstants.h"

@implementation APPSSearchViewControllerConfigurator

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  [super configureViewController:controller];
  UINib *nib = [UINib nibWithNibName:@"APPSHastagTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kHashtagResultCellIdentifier];
  controller.tableView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
}

- (void)configureSearchBar:(UISearchBar *)searchBar {
  searchBar.tintColor = [UIColor colorWithRed:0.792 green:0.231 blue:0.114 alpha:1.000];
  searchBar.backgroundImage = [[UIImage alloc] init];
  searchBar.placeholder = NSLocalizedString(@"Search", nil);
}

@end
