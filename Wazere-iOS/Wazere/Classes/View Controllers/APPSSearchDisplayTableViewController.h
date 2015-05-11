//
//  APPSSearcDisplayTableViewController.h
//  Wazere
//
//  Created by Gaidax on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSStrategyTableViewController.h"
#import "APPSSearchDisplayTableViewDelegate.h"

@interface APPSSearchDisplayTableViewController : APPSStrategyTableViewController

@property(strong, nonatomic) id<APPSSearchDisplayTableViewDelegate> delegate;
@property(strong, nonatomic) UISearchBar *searchBar;

@end
