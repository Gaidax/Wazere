//
//  APPSSearcDisplayTableViewController.m
//  Wazere
//
//  Created by Gaidax on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSearchDisplayTableViewController.h"
#import "APPSViewControllerConfiguratorProtocol.h"

@implementation APPSSearchDisplayTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  if ([self.configurator respondsToSelector:@selector(configureSearchBar:)]) {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self.delegate;
    self.navigationItem.titleView = self.searchBar;
    [self.configurator configureSearchBar:self.searchBar];
  }
}

- (IBAction)searchBarButtonPressed:(id)sender {
  if ([self.delegate respondsToSelector:@selector(searchNavigationBarButonPressed)]) {
    [self.delegate searchNavigationBarButonPressed];
  }
}

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
  [self.searchBar resignFirstResponder];
}

- (void)updateConstraintsForShownKeyboardBounds:(CGRect)keyboardBounds
                                 animationCurve:(UIViewAnimationCurve)curve {
  [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0)];
}

- (void)updateConstraintsForHiddenKeyboardWithBounds:(CGRect)bounds
                                      animationCurve:(UIViewAnimationCurve)curve {
  [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
