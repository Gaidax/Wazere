//
//  CustomTableViewController.h
//  flocknest
//
//  Created by iOS Developer on 11/22/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSViewController.h"

@interface APPSCustomTableViewController : APPSViewController<UITableViewDelegate>

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UITableView *tableView;

@end
