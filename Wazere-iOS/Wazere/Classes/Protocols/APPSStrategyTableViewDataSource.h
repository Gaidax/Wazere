//
//  CommandTableViewDataSource.h
//  flocknest
//
//  Created by iOS Developer on 11/26/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyDataSource.h"

@class APPSStrategyTableViewController;
@protocol APPSCommand;

@protocol APPSStrategyTableViewDataSource<UITableViewDataSource, APPSStrategyDataSource>

@property(weak, NS_NONATOMIC_IOSONLY) APPSStrategyTableViewController *parentController;

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController;

@end
