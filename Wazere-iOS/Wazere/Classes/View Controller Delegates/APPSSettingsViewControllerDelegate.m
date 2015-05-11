//
//  APPSSettingsViewControllerDelegate.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSettingsViewControllerDelegate.h"
#import "APPSSettingsConstants.h"
#import "APPSRACBaseRequest.h"
#import "APPSStrategyTableViewController.h"

typedef NS_ENUM(NSInteger, APPSSettingsCellType) {
  APPSSettingsCellTypeFacebookFriends,
  APPSSettingsCellTypeSearch,
  APPSSettingsCellTypePushNotifications,
  APPSSettingsCellTypePrivacyPolicy,
  APPSSettingsCellTypeTermsOfService,
  APPSSettingsCellTypeLogOut
};

@implementation APPSSettingsViewControllerDelegate
@synthesize parentController = _parentController;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
    return @"Settings screen";
}

#pragma mark - APPSStrategyTableViewDataSource

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController {
  self.parentController = parentController;
  [self.parentController.tableView reloadData];
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kSettingsViewCell forIndexPath:indexPath];

  cell.textLabel.text = [self localizedCellTitleForIndex:indexPath.section];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  cell.textLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(17.f);
  [cell layoutIfNeeded];
  cell.layer.cornerRadius = CGRectGetHeight(cell.frame) / 2.0;
  cell.clipsToBounds = YES;

  if (indexPath.section == APPSSettingsCellTypeLogOut) {
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithRed:0.761 green:0.212 blue:0.114 alpha:1.000];
    cell.accessoryView = nil;
  } else {
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.300];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryView = [[UIImageView alloc] initWithImage:IMAGE_WITH_NAME(@"cell_arrow")];
  }
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  CGFloat lastCellOffset = IS_WIDESCREEN ? WideScreenLogOutOffset : LogOutCellOffset;
  return section == APPSSettingsCellTypeLogOut ? lastCellOffset : DefaultDistanceBetweenCells;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.section) {
    case APPSSettingsCellTypeFacebookFriends:
      [self.parentController performSegueWithIdentifier:kSearchFacebookFriendsSegue
                                                 sender:self.parentController];
      break;
    case APPSSettingsCellTypeSearch:
      [self.parentController performSegueWithIdentifier:kSearchSegue sender:self.parentController];
      break;
    case APPSSettingsCellTypePushNotifications:
      [self.parentController performSegueWithIdentifier:kPushNotificationsSettingsSegue
                                                 sender:self.parentController];
      break;
    case APPSSettingsCellTypeLogOut:
      [self handleLogOutCellPressed];
      break;
    case APPSSettingsCellTypePrivacyPolicy:
      [self.parentController performSegueWithIdentifier:kPrivacyPolicySettingSegue sender:self.parentController];
      break;
    case APPSSettingsCellTypeTermsOfService:
      [self.parentController performSegueWithIdentifier:kTermsOfServiceSettingSegue sender:self.parentController];
      break;
  }
}

- (void)handleLogOutCellPressed {
  NSDictionary *params = nil;
  NSData *deviceTooken = [[APPSUtilityFactory sharedInstance] notificationUtility].deviceToken;

  if (deviceTooken) {
    params = @{ kDeviceTokenKey : deviceTooken };
  }

  APPSRACBaseRequest *signOutRequest = [[APPSRACBaseRequest alloc] initWithObject:nil
                                                                           params:params
                                                                           method:HTTPMethodDELETE
                                                                          keyPath:KeyPathSignOut
                                                                       disposable:nil];

  [signOutRequest.execute subscribeNext:^(NSDictionary *response) {
    
  } error:^(NSError *error) { NSLog(@"%@", error); }];
  [APPSSettingsViewControllerDelegate cleanUserDataAndShowStartScreen];
}

#pragma mark - Helpers

- (NSString *)localizedCellTitleForIndex:(NSInteger)index {
  NSString *title;
  switch (index) {
    case APPSSettingsCellTypeFacebookFriends:
      title = @"Find Facebook Friends to Follow";
      break;
    case APPSSettingsCellTypeSearch:
      title = @"Search by Users and Hashtags";
      break;
    case APPSSettingsCellTypePushNotifications:
      title = @"Push Notification Settings";
      break;
    case APPSSettingsCellTypePrivacyPolicy:
      title = @"Privacy Policy";
      break;
    case APPSSettingsCellTypeTermsOfService:
      title = @"Terms of Service";
      break;
    case APPSSettingsCellTypeLogOut:
      title = @"Log Out";
      break;
  }
  return NSLocalizedString(title, nil);
}

+ (void)cleanUserDataAndShowStartScreen {
  [[[APPSUtilityFactory sharedInstance] facebookUtility] closeSession];
  [[[APPSUtilityFactory sharedInstance] twitterUtility] logOut];
  [[[APPSUtilityFactory sharedInstance] notificationUtility] setDidSendDeviceToken:NO];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionTokenKey];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:CurrentUserIdKey];

  [[[APPSAppDelegate sharedInstance] window].rootViewController dismissViewControllerAnimated:YES
                                                                                   completion:NULL];
}

@end
