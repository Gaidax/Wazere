//
//  CustomTableViewController.h
//  flocknest
//
//  Created by iOS Developer on 11/22/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSRACViewController.h"

@interface APPSRACCustomTableViewController : APPSRACViewController<UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@end

@interface APPSRACCustomTableViewController ()

@end
