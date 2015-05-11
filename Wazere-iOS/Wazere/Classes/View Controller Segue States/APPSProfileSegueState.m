//
//  APPSSettingsSegueState.m
//  Wazere
//
//  Created by Gaidax on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileSegueState.h"

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerDelegate.h"

#import "APPSStrategyTableViewController.h"

#import "APPSSettingsViewControllerConfigurator.h"
#import "APPSSettingsViewControllerDelegate.h"
#import "APPSSettingsSegueState.h"

#import "APPSNavigationViewController.h"
#import "APPSEditProfileViewControllerConfigurator.h"
#import "APPSEditProfileViewControllerDelegate.h"

@implementation APPSProfileSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kSettingsSegue]) {
    [self configureSettingsViewController:segue];
  } else if ([segue.identifier isEqualToString:kEditMyProfileSegue]) {
    [self configureEditMyProfileController:segue];
  }
}

- (void)configureSettingsViewController:(UIStoryboardSegue *)segue {
  APPSStrategyTableViewController *settingsController =
      (APPSStrategyTableViewController *)segue.destinationViewController;
  settingsController.configurator = [[APPSSettingsViewControllerConfigurator alloc] init];
  APPSSettingsViewControllerDelegate *settingsDelegate =
      [[APPSSettingsViewControllerDelegate alloc] init];
  settingsController.delegate = settingsDelegate;
  settingsController.dataSource = settingsDelegate;
  settingsController.state = [[APPSSettingsSegueState alloc] init];
}

- (void)configureEditMyProfileController:(UIStoryboardSegue *)segue {
  APPSNavigationViewController *navigationViewController =
      (APPSNavigationViewController *)segue.destinationViewController;
  APPSStrategyTableViewController *editMyProfileController =
      (APPSStrategyTableViewController *)navigationViewController.viewControllers[0];
  editMyProfileController.configurator = [[APPSEditProfileViewControllerConfigurator alloc] init];
  APPSEditProfileViewControllerDelegate *delegate =
      [[APPSEditProfileViewControllerDelegate alloc] init];
  editMyProfileController.dataSource = delegate;
  editMyProfileController.delegate = delegate;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  return self;
}

@end
