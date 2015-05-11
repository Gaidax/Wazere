//
//  CustomTableViewController.m
//  flocknest
//
//  Created by iOS Developer on 11/22/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSRACCustomTableViewController.h"

@interface APPSRACCustomTableViewController ()

@end

@implementation APPSRACCustomTableViewController

- (void)dealloc {
  _tableView.delegate = nil;
  _tableView.dataSource = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSArray *selectedIndexPathes = [self.tableView indexPathsForSelectedRows];
  for (NSIndexPath *currentIndexPath in selectedIndexPathes) {
    [self.tableView deselectRowAtIndexPath:currentIndexPath animated:YES];
    if ([self respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
      [self tableView:self.tableView didDeselectRowAtIndexPath:currentIndexPath];
    }
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
