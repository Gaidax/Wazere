//
//  APPSSettingsSegueState.m
//  Wazere
//
//  Created by Gaidax on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSettingsSegueState.h"
#import "APPSSettingsConstants.h"

#import "APPSSearchDisplayTableViewController.h"
#import "APPSSearchViewControllerConfigurator.h"
#import "APPSSearchViewControllerDelegate.h"

#import "APPSFacebookSearchDelegate.h"
#import "APPSFacebookSearchConfigurator.h"

#import "APPSPushNotificationsViewControllerConfigurator.h"
#import "APPSPushNotificationsViewControllerDelegate.h"

#import "APPSWebViewController.h"

@implementation APPSSettingsSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kSearchSegue]) {
    [self prepareSearchByUsersAndHashtagsViewControllerWithSegue:segue];
  } else if ([segue.identifier isEqualToString:kSearchFacebookFriendsSegue]) {
    [self prepareFacebookSearchViewControllerWithSegue:segue];
  } else if ([segue.identifier isEqualToString:kPushNotificationsSettingsSegue]) {
    [self preparePushNotificationsSettingsViewControllerWithSegue:segue];
  } else if ([segue.identifier isEqualToString:kPrivacyPolicySettingSegue]) {
    APPSWebViewController *destination = (APPSWebViewController *)[segue destinationViewController];
    destination.url = kPolicyAddress;
  } else if ([segue.identifier isEqualToString:kTermsOfServiceSettingSegue]) {
    APPSWebViewController *destination = (APPSWebViewController *)[segue destinationViewController];
    destination.url = kTermsAddress;
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSSettingsSegueState"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Unknown identifier"
                                 }]);
  }
}

- (void)prepareSearchByUsersAndHashtagsViewControllerWithSegue:(UIStoryboardSegue *)segue {
  APPSSearchDisplayTableViewController *searchController =
      (APPSSearchDisplayTableViewController *)segue.destinationViewController;
  searchController.configurator = [[APPSSearchViewControllerConfigurator alloc] init];
  APPSSearchViewControllerDelegate *searchDelegate =
      [[APPSSearchViewControllerDelegate alloc] init];
  searchController.delegate = searchDelegate;
  searchController.dataSource = searchDelegate;
}

- (void)prepareFacebookSearchViewControllerWithSegue:(UIStoryboardSegue *)segue {
  APPSStrategyTableViewController *facebookController =
      (APPSStrategyTableViewController *)segue.destinationViewController;
  facebookController.configurator = [[APPSFacebookSearchConfigurator alloc] init];
  APPSFacebookSearchDelegate *facebookDelegate = [[APPSFacebookSearchDelegate alloc] init];
  facebookController.delegate = facebookDelegate;
  facebookController.dataSource = facebookDelegate;
}

- (void)preparePushNotificationsSettingsViewControllerWithSegue:(UIStoryboardSegue *)segue {
  APPSStrategyTableViewController *pushSettingsController =
      (APPSStrategyTableViewController *)segue.destinationViewController;
  pushSettingsController.configurator =
      [[APPSPushNotificationsViewControllerConfigurator alloc] init];
  APPSPushNotificationsViewControllerDelegate *pushSettingsDelegate =
      [[APPSPushNotificationsViewControllerDelegate alloc] init];
  pushSettingsController.delegate = pushSettingsDelegate;
  pushSettingsController.dataSource = pushSettingsDelegate;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

@end
