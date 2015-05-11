//
//  SearchDelegate.m
//  Presentation project
//
//  Created by Petr Yanenko on 8/29/13.
//  Copyright (c) 2013 Petr Yanenko. All rights reserved.
//

#import "APPSSearchDelegate.h"
#import "APPSMapViewController.h"
#import "APPSSearchQueue.h"

@interface APPSSearchDelegate ()

@property(weak) APPSMapViewController *controller;
@property NSCache *cachedResponses;
@property NSArray *responseArray;
@property APPSSearchQueue *queue;

@end

@implementation APPSSearchDelegate

- (id)initWithMapController:(APPSMapViewController *)controller {
  self = [super init];
  if (self) {
    self.controller = controller;
    self.cachedResponses = [NSCache new];
    self.queue = [APPSSearchQueue new];
    // self.geocoder = [CLGeocoder new];
  }
  return self;
}

#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
    shouldReloadTableForSearchString:(NSString *)searchString {
  NSArray *response = nil;
  if (searchString.length > 1 &&
      (response = [self.cachedResponses objectForKey:searchString]) == nil) {
    [self.queue geocodeAddressString:searchString
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (placemarks == nil) {
                         NSLog(@"%@\n", error);
                       } else {
                         [self.cachedResponses setObject:placemarks forKey:searchString];
                       }
                       // NSLog(@"%@ %@", searchString, placemarks[0]);
                       self.responseArray = placemarks;
                       [controller.searchResultsTableView reloadData];
                   }];
    return NO;
  }
  self.responseArray = response;
  return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
  UIView *searchBarContainer = nil;
  if (!IS_OS_8_OR_LATER) {
    searchBarContainer = controller.searchBar.subviews[0];
  } else {
    searchBarContainer = controller.searchBar;
  }
  for (UIView *subview in searchBarContainer.subviews) {
    if ([subview isMemberOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      if (!IS_OS_8_OR_LATER) {
        [subview setAlpha:1.0];
      } else {
        [subview setAlpha:0.7];
      }
      break;
    }
  }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
  UIView *searchBarContainer = nil;
  if (!IS_OS_8_OR_LATER) {
    searchBarContainer = controller.searchBar.subviews[0];
  } else {
    searchBarContainer = controller.searchBar;
  }
  for (UIView *subview in searchBarContainer.subviews) {
    if ([subview isMemberOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [subview setAlpha:0.];
      break;
    }
  }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.responseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *const reuseIdentifier = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:reuseIdentifier];
  }
  CLPlacemark *currentPlacemark = (CLPlacemark *)self.responseArray[indexPath.row];
  NSDictionary *addressDictionary = currentPlacemark.addressDictionary;
  NSArray *address = addressDictionary[@"FormattedAddressLines"];
  NSString *addressString = @"";
  for (NSString *currentSubAddress in address) {
    addressString = [addressString stringByAppendingFormat:@"%@, ", currentSubAddress];
  }
  if (addressString.length < 3) {
    NSLog(@"%@\n", [NSError errorWithDomain:@"APPSSearchDelegate"
                                       code:0
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"Address is empty"
                                   }]);
  } else {
    cell.textLabel.text = [addressString substringToIndex:addressString.length - 2];
  }
  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CLPlacemark *currentPlacemark = (CLPlacemark *)self.responseArray[indexPath.row];
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(
      currentPlacemark.location.coordinate, currentPlacemark.region.radius * 2.0,
      currentPlacemark.region.radius * 2.0);
  [self.controller addAnnotationWithPlacemark:currentPlacemark];
  [self.controller goToRegion:region];
  [self.controller.searchDisplayController setActive:NO animated:YES];
}

@end
