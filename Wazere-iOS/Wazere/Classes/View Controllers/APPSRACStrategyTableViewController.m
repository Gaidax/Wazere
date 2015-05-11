//
//  ParseTableViewController.m
//  flocknest
//
//  Created by iOS Developer on 11/26/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSRACStrategyTableViewController.h"
#import "APPSFunctionalLogicDelegate.h"
#import "APPSRACTableViewDelegate.h"

@interface APPSRACStrategyTableViewController ()

@property(assign, NS_NONATOMIC_IOSONLY) UIEdgeInsets normalTableViewInstets;

@end

@implementation APPSRACStrategyTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.tintColor = [UIColor whiteColor];
  [self.refreshControl addTarget:self
                          action:@selector(refresh:)
                forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  [self.mainLogicDelegate mainLogicWithViewController:self viewModel:[self.delegate viewModel]];
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
    [self.delegate reloadTableViewController:self];
  }
  self.disableReload = NO;
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (self.delegate != (id<APPSRACTableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
    return [self.delegate sectionIndexTitlesForTableView:tableView];
  }
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (self.delegate != (id<APPSRACTableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
    return [self.delegate tableView:tableView titleForHeaderInSection:section];
  }

  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView
    sectionForSectionIndexTitle:(NSString *)title
                        atIndex:(NSInteger)index

{
  if (self.delegate != (id<APPSRACTableViewDelegate>)self &&
      [self.delegate
          respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
    return [self.delegate tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.delegate != (id<APPSRACTableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
    return [self.delegate numberOfSectionsInTableView:tableView];
  }
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.delegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

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

#pragma mark - ViewControllerDelegate

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !(self.delegate != (id<APPSRACTableViewDelegate>)self &&
      [self.delegate
          respondsToSelector:@selector(viewController:shouldPerformSegueWithIdentifier:sender:)]) || [self.delegate viewController:self
        shouldPerformSegueWithIdentifier:identifier
                                  sender:sender];
}

- (void)disposeViewController {
  [super disposeViewController];
  if (self.delegate != (id<APPSRACTableViewDelegate>)self &&
      [self.delegate respondsToSelector:@selector(removeViewController:)]) {
    [self.delegate removeViewController:self];
  }
}

- (void)updateConstraintsForShownKeyboardBounds:(CGRect)keyboardBounds
                                 animationCurve:(UIViewAnimationCurve)curve {
  self.normalTableViewInstets = self.tableView.contentInset;
  [self.tableView
      setContentInset:UIEdgeInsetsMake(self.normalTableViewInstets.top,
                                       self.normalTableViewInstets.left, keyboardBounds.size.height,
                                       self.normalTableViewInstets.right)];
}

- (void)updateConstraintsForHiddenKeyboardWithBounds:(CGRect)bounds
                                      animationCurve:(UIViewAnimationCurve)curve {
  UIEdgeInsets insets = self.tableView.contentInset;
  [self.tableView
      setContentInset:UIEdgeInsetsMake(insets.top, insets.left, self.normalTableViewInstets.bottom,
                                       insets.right)];
}

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
  [self.firstResponder resignFirstResponder];
  self.firstResponder = nil;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.mainLogicDelegate forKey:@"mainLogicDelegate"];
  [coder encodeObject:self.delegate forKey:@"delegate"];
  [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  self.mainLogicDelegate = [coder decodeObjectForKey:@"mainLogicDelegate"];
  self.delegate = [coder decodeObjectForKey:@"delegate"];
  [super decodeRestorableStateWithCoder:coder];
}

@end
