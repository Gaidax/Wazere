//
//  ParseTableViewController.m
//  flocknest
//
//  Created by iOS Developer on 11/26/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSStrategyTableViewController.h"
#import "APPSStrategyTableViewDataSource.h"
#import "APPSStrategyTableViewDelegate.h"

@interface APPSStrategyTableViewController ()

@property(assign, NS_NONATOMIC_IOSONLY) UIEdgeInsets normalTableInsets;

@end

@implementation APPSStrategyTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.tintColor = [UIColor colorWithRed:0.635 green:0.141 blue:0.247 alpha:1.000];
  [self.refreshControl addTarget:self
                          action:@selector(refresh:)
                forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  self.tableView.scrollsToTop = YES;

  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)refreshControl {
  [self reloadTable];
  [refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadTable];
}

- (void)reloadTable {
  if (!self.disableReload) {
    [self.dataSource reloadTableViewController:self];
  }
  self.disableReload = NO;
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (self.dataSource != (id<APPSStrategyTableViewDataSource>)self &&
      [self.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
    return [self.dataSource sectionIndexTitlesForTableView:tableView];
  }
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (self.dataSource != (id<APPSStrategyTableViewDataSource>)self &&
      [self.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
    return [self.dataSource tableView:tableView titleForHeaderInSection:section];
  }

  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView
    sectionForSectionIndexTitle:(NSString *)title
                        atIndex:(NSInteger)index {
  if (self.dataSource != (id<APPSStrategyTableViewDataSource>)self &&
      [self.dataSource
          respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
    return [self.dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.dataSource != (id<APPSStrategyTableViewDataSource>)self &&
      [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
    return [self.dataSource numberOfSectionsInTableView:tableView];
  }
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
    return [self.delegate tableView:tableView heightForHeaderInSection:section];
  }
  return self.tableView.sectionHeaderHeight == 1 ? 0 : self.tableView.sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
    return [self.delegate tableView:tableView viewForHeaderInSection:section];
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
    return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
  }
  return [self.tableView rowHeight];
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
    [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
  }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
    return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
  }
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  };
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != (id<UITableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
    [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
  };
}

- (void)updateConstraintsForShownKeyboardBounds:(CGRect)keyboardBounds
                                 animationCurve:(UIViewAnimationCurve)curve {
  self.normalTableInsets = self.tableView.contentInset;
  if ([self.delegate
          respondsToSelector:@selector(updateContentOffsetForKeyboardBounds:normalTableInsets:)]) {
    [self.delegate updateContentOffsetForKeyboardBounds:keyboardBounds
                                      normalTableInsets:self.normalTableInsets];
  } else {
    [self.tableView
        setContentInset:UIEdgeInsetsMake(self.normalTableInsets.top, self.normalTableInsets.left,
                                         keyboardBounds.size.height, self.normalTableInsets.right)];
  }
}

- (void)updateConstraintsForHiddenKeyboardWithBounds:(CGRect)bounds
                                      animationCurve:(UIViewAnimationCurve)curve {
  UIEdgeInsets insets = self.tableView.contentInset;
  [self.tableView setContentInset:UIEdgeInsetsMake(insets.top, insets.left,
                                                   self.normalTableInsets.bottom, insets.right)];
}

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
  [self.view endEditing:YES];
  [self.firstResponder resignFirstResponder];
  self.firstResponder = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [self.delegate scrollViewDidEndDecelerating:scrollView];
  }
}
@end
