//
//  APPSSearchViewControllerDelegate.m
//  Wazere
//
//  Created by Gaidax on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSearchViewControllerDelegate.h"
#import "APPSSearchDisplayTableViewController.h"
#import "APPSProfileViewController.h"
#import "APPSHashtagPhotosDelegate.h"
#import "APPSHastagPhotosConfigurator.h"
#import "APPSSearchConstants.h"

#import "APPSSomeUser.h"
#import "APPSHashtagModel.h"
#import "APPSPaginationModel.h"

#import "APPSRACBaseRequest.h"

#import "APPSHastagTableViewCell.h"

@interface APPSSearchViewControllerDelegate ()
@property(strong, nonatomic) APPSPaginationModel *paginationModel;
@property(strong, nonatomic) NSString *searchByFilter;
@property(strong, nonatomic) APPSRACBaseRequest *searchRequest;
@property(strong, nonatomic) APPSRACBaseRequest *hashtagRequest;
@end

@implementation APPSSearchViewControllerDelegate

static NSString *const searchByUsersFilter = @"searchByUsers";
static NSString *const searchByHashtagsFilter = @"searchByHashtags";

- (void)reloadUsersList {
  APPSSearchDisplayTableViewController *tableViewController =
      ((APPSSearchDisplayTableViewController *)self.parentController);
  [self clearLoadedData];
  [self updateSearchBarPlaceholder];
  [self loadResultsWithSearchQuery:tableViewController.searchBar.text];
}

- (NSString *)searchByFilter {
  if (!_searchByFilter) {
    _searchByFilter = searchByUsersFilter;
  }
  return _searchByFilter;
}

- (NSString *)screenName {
  return @"Search by users and hashtags";
}

#pragma mark - APPSStrategyTableViewDelegate

- (void)searchNavigationBarButonPressed {
  UISearchBar *searchBar =
      ((APPSSearchDisplayTableViewController *)self.parentController).searchBar;
  [searchBar isFirstResponder] ? [searchBar resignFirstResponder]
                               : [searchBar becomeFirstResponder];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (!section) {
    APPSSegmentSuplementaryView *segmentView = [tableView
        dequeueReusableHeaderFooterViewWithIdentifier:kSearchSupplementaryViewIdentifier];

    if (!segmentView) {
      CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.parentController.view.frame),
                                SegmentHeaderViewHeight);
      segmentView = [[APPSSegmentSuplementaryView alloc] initWithFrame:frame];
      segmentView.delegate = self;
    }

    segmentView.segmentControl.selectedSegmentIndex =
        [self.searchByFilter isEqualToString:searchByHashtagsFilter];

    return segmentView;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return !section ? SegmentHeaderViewHeight : 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.searchByFilter isEqualToString:searchByUsersFilter] || !self.usersModels.count) {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  } else {
    tableView.separatorColor = [UIColor colorWithWhite:1.000 alpha:0.700];
    APPSHashtagModel *hashtag = (self.usersModels)[indexPath.row];

    APPSHastagTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:kHashtagResultCellIdentifier
                                        forIndexPath:indexPath];
    cell.hashtagLabel.text = [NSString stringWithFormat:@"#%@", hashtag.name];
    cell.postsCountLabel.text = [NSString stringWithFormat:@"%ld posts", (long)hashtag.mediaCount];
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.searchByFilter isEqualToString:searchByUsersFilter] || !self.usersModels.count) {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  } else {
    [self openUsersListForHashTag:(self.usersModels)[indexPath.row]];
  }
}

- (void)openUsersListForHashTag:(APPSHashtagModel *)hashTag {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  APPSProfileViewController *hashtagPhototsController =
      [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  APPSHastagPhotosConfigurator *configurator = [[APPSHastagPhotosConfigurator alloc] init];
  configurator.hashtag = hashTag;
  hashtagPhototsController.configurator = configurator;
  APPSHashtagPhotosDelegate *delegate = [[APPSHashtagPhotosDelegate alloc]
      initWithViewController:hashtagPhototsController
                        user:[[APPSCurrentUserManager sharedInstance] currentUser]];
  delegate.hashtag = hashTag;
  delegate.parentController.navigationItem.rightBarButtonItem = nil;
  hashtagPhototsController.delegate = delegate;
  hashtagPhototsController.dataSource = delegate;

  [self.parentController.navigationController pushViewController:hashtagPhototsController
                                                        animated:YES];
}

#pragma mark - APPSSegmentSuplementaryViewDelegate

- (void)suplementaryView:(APPSSegmentSuplementaryView *)view
            valueChanged:(UISegmentedControl *)sender {
  self.searchByFilter = sender.selectedSegmentIndex ? searchByHashtagsFilter : searchByUsersFilter;
  [self reloadUsersList];
}

- (NSArray *)suplementaryViewButtonItems {
  return @[ NSLocalizedString(@"Users", nil), NSLocalizedString(@"Hashtags", nil) ];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if (text.length) {
    [self clearLoadedData];
    [self loadResultsWithSearchQuery:[searchBar.text stringByAppendingString:text]];
  }
  return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (!searchText.length) {
    self.currentResultState = APPSLoadingResultStateNoResults;
    [self.searchRequest cancel];
    [self.hashtagRequest cancel];

    if ([searchBar isFirstResponder]) {
      [searchBar resignFirstResponder];
    }
    [self clearLoadedData];
  }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  [self updateSearchBarPlaceholder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  [self updateSearchBarPlaceholder];
}

- (void)updateSearchBarPlaceholder {
  UISearchBar *searchBar =
      ((APPSSearchDisplayTableViewController *)self.parentController).searchBar;

  if ([searchBar isFirstResponder]) {
    BOOL usersSearch = [self.searchByFilter isEqualToString:searchByUsersFilter];
    NSString *placeholder =
        [NSString stringWithFormat:NSLocalizedString(@"Search for a %@", nil),
                                   (usersSearch ? NSLocalizedString(@"user", nil)
                                                : NSLocalizedString(@"hashtag", nil))];

    searchBar.placeholder = placeholder;
  } else {
    searchBar.placeholder = NSLocalizedString(@"Search", nil);
  }
}

- (void)clearLoadedData {
  [super clearLoadedData];
  [self.parentController.tableView reloadData];
}

#pragma mark - Data loading

- (void)loadResultsWithSearchQuery:(NSString *)searchQuery {
  NSString *trimmedQuery = [searchQuery
      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.currentResultState = APPSLoadingResultStateLoading;
  [self.searchByFilter isEqualToString:searchByUsersFilter] ? [self searchByUsername:trimmedQuery]
                                                            : [self searchByHashtags:trimmedQuery];
}

#pragma mark - Search by Usernames

- (void)searchByUsername:(NSString *)username {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
    @"search_str" : username
  }];
  if (self.usersModels.count != 0 && self.paginationModel.currentPage != 0) {
    [params setValue:@(self.paginationModel.currentPage + 1) forKey:@"page"];
  }
  [self.searchRequest cancel];
  self.searchRequest = [[APPSRACBaseRequest alloc] initWithObject:nil
                                                           params:[params copy]
                                                           method:HTTPMethodGET
                                                          keyPath:kSearchKeyPath
                                                       disposable:nil];

  @weakify(self);
  [self.searchRequest.execute subscribeNext:^(NSDictionary *response) {
      @strongify(self);
      [self updateSearchResultsWithResponse:response];
      [self.parentController.tableView reloadData];
  } error:^(NSError *error) {
      @strongify(self);
      if (error.code == HTTPStausCodeCanceled) {
        self.currentResultState = APPSLoadingResultStateLoading;
      } else {
        self.currentResultState = APPSLoadingResultStateError;
        NSLog(@"%@", error);
      }
      [self.parentController.tableView reloadData];
  }];
}

- (void)updateSearchResultsWithResponse:(NSDictionary *)response {
  NSError *error = nil;
  NSMutableArray *newSearchResults = [[NSMutableArray alloc] init];
  for (NSDictionary *userDict in response[@"users"]) {
    APPSSomeUser *user = [[APPSSomeUser alloc] initWithDictionary:userDict error:&error];
    if (user) {
      [newSearchResults addObject:user];
    } else {
      NSLog(@"%@", error);
    }
  }

  self.paginationModel =
      [[APPSPaginationModel alloc] initWithDictionary:response[@"pagination"] error:&error];

  [self.usersModels addObjectsFromArray:newSearchResults];
  if (!newSearchResults.count) {
    self.currentResultState = APPSLoadingResultStateNoResults;
  } else {
    self.currentResultState = APPSLoadingResultStateNormal;
  }
}

#pragma mark - Search by Hashtags

- (void)searchByHashtags:(NSString *)hashtag {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
    @"search_str" : hashtag
  }];
  if (self.usersModels.count != 0 && self.paginationModel.currentPage != 0) {
    [params setValue:@(self.paginationModel.currentPage + 1) forKey:@"page"];
  }

  [self.hashtagRequest cancel];

  self.hashtagRequest = [[APPSRACBaseRequest alloc] initWithObject:nil
                                                            params:params
                                                            method:HTTPMethodGET
                                                           keyPath:kHashtagKeyPath
                                                        disposable:nil];
  @weakify(self);
  [self.hashtagRequest.execute subscribeNext:^(NSDictionary *response) {
      @strongify(self);
      [self updateHashtagsResultsWithResponse:response];
      [self.parentController.tableView reloadData];
  } error:^(NSError *error) {
      @strongify(self);
      if (error.code == HTTPStausCodeCanceled) {
        self.currentResultState = APPSLoadingResultStateLoading;
      } else {
        self.currentResultState = APPSLoadingResultStateError;
        NSLog(@"%@", error);
      }
      [self.parentController.tableView reloadData];
  }];
}

- (void)updateHashtagsResultsWithResponse:(NSDictionary *)response {
  NSError *error = nil;
  NSMutableArray *newSearchResults = [[NSMutableArray alloc] init];
  for (NSDictionary *tagDict in response[@"tags"]) {
    APPSHashtagModel *tag = [[APPSHashtagModel alloc] initWithDictionary:tagDict error:&error];

    [newSearchResults addObject:tag];
  }

  self.paginationModel =
      [[APPSPaginationModel alloc] initWithDictionary:response[@"pagination"] error:&error];

  [self.usersModels addObjectsFromArray:newSearchResults];
  if (!newSearchResults.count) {
    self.currentResultState = APPSLoadingResultStateNoResults;
  } else {
    self.currentResultState = APPSLoadingResultStateNormal;
  }
}

@end
