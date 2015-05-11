//
//  CommandTableViewDataSource.h
//  flocknest
//
//  Created by iOS Developer on 11/26/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyControllerDelegate.h"

@class APPSRACStrategyTableViewController;

@protocol APPSRACTableViewDelegate<UITableViewDataSource, APPSStrategyControllerDelegate>

- (void)reloadTableViewController:(APPSRACStrategyTableViewController __weak *)parentController;

@end
