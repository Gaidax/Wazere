//
//  APPSFiltersViewControllerDelegate.m
//  Wazere
//
//  Created by Gaidax on 11/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFiltersViewControllerDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSHomeDelegate.h"
#import "APPSFiltersTableViewCell.h"

@interface APPSFiltersViewControllerDelegate ()
@property(strong, nonatomic) NSArray *filtersTitles;
@property(weak, nonatomic) id<APPSFiltersSelectionDelegate> delegate;
@end

@implementation APPSFiltersViewControllerDelegate
@synthesize parentController = _parentController;

static CGFloat const FilterCellHeight = 36.f;

- (instancetype)initWithTitles:(NSArray *)filterTitles
                      delegate:(id<APPSFiltersSelectionDelegate>)delegate {
  self = [super init];
  if (self) {
    _filtersTitles = filterTitles;
    _delegate = delegate;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
    return @"Filters select";
}

#pragma mark - APPSStrategyTableViewDataSource

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController {
  [parentController.tableView reloadData];
  self.parentController = parentController;
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  APPSFiltersTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kHomeFiltersTableViewCellIdentifier
                                      forIndexPath:indexPath];

  NSString *filterTitle = [self filtersTitles][indexPath.row];
  cell.textLabel.text = filterTitle;
  cell.imageView.image =
      [UIImage imageNamed:[NSString stringWithFormat:@"%@_filter", [filterTitle lowercaseString]]];

  APPSHomeDelegate *homeDelegate = (APPSHomeDelegate *)_delegate;
  if ([homeDelegate.filter caseInsensitiveCompare:filterTitle] == NSOrderedSame) {
    [tableView selectRowAtIndexPath:indexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
  }

  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.filtersTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return FilterCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.delegate respondsToSelector:@selector(filterSelected:)]) {
      NSString *serverFilter = [[[self filtersTitles] objectAtIndex:indexPath.row] lowercaseString];
    [self.delegate filterSelected:serverFilter];
  }
}

@end
