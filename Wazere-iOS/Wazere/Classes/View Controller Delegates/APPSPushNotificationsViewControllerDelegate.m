//
//  APPSPushNotificationsViewControllerDelegate.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPushNotificationsViewControllerDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSettingTableViewCell.h"
#import "APPSSettingsConstants.h"
#import "APPSSettingsModel.h"
#import "APPSRACBaseRequest.h"

typedef NS_ENUM(NSInteger, APPSPushNotificationsSetting) {
  APPSPushNotificationsSettingLikes,
  APPSPushNotificationsSettingComments,
  APPSPushNotificationsSettingNewFollowers,
  APPSPushNotificationsSettingFacebookFriends,
  APPSPushNotificationsSettingDirectActivity,
  APPSPushNotificationsCount
};

@interface APPSPushNotificationsViewControllerDelegate () <UIActionSheetDelegate>
@property(strong, nonatomic) APPSSettingsModel *settingsModel;
@end

@implementation APPSPushNotificationsViewControllerDelegate
@synthesize parentController = _parentController;

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  return self;
}

- (NSString *)screenName {
    return @"Push notifications settings";
}

#pragma mark - Settings Loading

- (void)loadSettings {
  APPSCurrentUser *user = [[APPSCurrentUserManager sharedInstance] currentUser];
  APPSRACBaseRequest *settingsRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:kSettingsKeyPath, user.userId]
          disposable:nil];
  @weakify(self);
  [settingsRequest.execute subscribeNext:^(NSDictionary *response) {
    @strongify(self);
      self.settingsModel =
          [[APPSSettingsModel alloc] initWithDictionary:response[@"settings"] error:nil];
      [self.parentController.tableView reloadData];
  } error:^(NSError *error) { NSLog(@"Error loading settings: %@", error); }];
}

- (void)saveSettings {
  APPSSpinnerView *spinnerView =
      [[APPSSpinnerView alloc] initWithSuperview:self.parentController.view];

  APPSCurrentUser *user = [[APPSCurrentUserManager sharedInstance] currentUser];
  APPSRACBaseRequest *settingsRequest = [[APPSRACBaseRequest alloc]
      initWithObject:self.settingsModel
              method:HTTPMethodPUT
             keyPath:[NSString stringWithFormat:kSettingsKeyPath, user.userId]
          disposable:nil];
  [spinnerView startAnimating];
  @weakify(self);
  [settingsRequest.execute subscribeNext:^(NSDictionary *response) {
    @strongify(self);
      [spinnerView stopAnimating];
      self.settingsModel =
          [[APPSSettingsModel alloc] initWithDictionary:response[@"settings"] error:nil];
      [self.parentController.tableView reloadData];
  } error:^(NSError *error) {
      [spinnerView stopAnimating];
      NSLog(@"Error saving settings: %@", error);
  }];
}

- (APPSPushSettingValue)valueForSetting:(APPSPushNotificationsSetting)setting {
  APPSSettingsModel *settings = self.settingsModel;

  switch (setting) {
    case APPSPushNotificationsSettingLikes:
      return settings.likes;
    case APPSPushNotificationsSettingComments:
      return settings.comments;
    case APPSPushNotificationsSettingDirectActivity:
      return settings.directActivity;
    case APPSPushNotificationsSettingFacebookFriends:
      return settings.facebookFriends;
    case APPSPushNotificationsSettingNewFollowers:
      return settings.followers;
    default:
      return 0;
  }
}

- (void)setValue:(APPSPushSettingValue)value forSetting:(APPSPushNotificationsSetting)setting {
  APPSSettingsModel *settings = self.settingsModel;

  switch (setting) {
    case APPSPushNotificationsSettingLikes:
      settings.likes = value;
      break;
    case APPSPushNotificationsSettingComments:
      settings.comments = value;
      break;
    case APPSPushNotificationsSettingDirectActivity:
      settings.directActivity = value;
      break;
    case APPSPushNotificationsSettingFacebookFriends:
      settings.facebookFriends = value;
      break;
    case APPSPushNotificationsSettingNewFollowers:
      settings.followers = value;
      break;
    default:
      break;
  }
}

- (NSArray *)settingsTitleKeys {
  return @[ @"Likes", @"Comments", @"New Followers", @"Friends from Facebook", @"Direct Activity" ];
}

- (NSArray *)valuesTitlesKeys {
  return @[ @"Off", @"From everyone", @"From people I follow" ];
}

- (NSArray *)onOffValuesTitlesKeys {
  return @[ @"Off", @"On" ];
}

- (BOOL)isOnOffSetting:(APPSPushNotificationsSetting)setting {
  return !(setting == APPSPushNotificationsSettingLikes ||
           setting == APPSPushNotificationsSettingComments);
}

#pragma mark - APPSStrategyTableViewDataSource

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController {
  self.parentController = parentController;
  [self loadSettings];
}

#pragma mark - APPSStrategyTableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.settingsModel ? APPSPushNotificationsCount : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  APPSSettingTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kPushNotificationsTableViewCell
                                      forIndexPath:indexPath];
  cell.settingTitle.text = [self settingsTitleKeys][indexPath.row];
  NSString *stringKeyValue;
  APPSPushSettingValue value = [self valueForSetting:indexPath.row];
  if ([self isOnOffSetting:indexPath.row]) {
    stringKeyValue = [self onOffValuesTitlesKeys][value];
  } else {
    stringKeyValue = [self valuesTitlesKeys][value];
  }
  cell.settingValue.text = NSLocalizedString(stringKeyValue, nil);
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [[self actionSheetForSetting:indexPath.row] showInView:self.parentController.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return PushNotificationsCellHeight;
}

#pragma mark - UIActionSheet

- (UIActionSheet *)actionSheetForSetting:(APPSPushNotificationsSetting)setting {
  BOOL isOnOff = [self isOnOffSetting:setting];
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
  SEL selector = NSSelectorFromString(@"_alertController");
  if ([actionSheet respondsToSelector:selector]) {
    UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
    if ([alertController isKindOfClass:[UIAlertController class]]) {
      alertController.view.tintColor =
          [UIColor colorWithRed:0.957 green:0.553 blue:0.463 alpha:1.000];
    }
  }

  if (isOnOff) {
    [actionSheet
        addButtonWithTitle:NSLocalizedString([self onOffValuesTitlesKeys][APPSPushSettingValueAll],
                                             nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(
                                        [self valuesTitlesKeys][APPSPushSettingValueOff], nil)];
  } else {
    [actionSheet addButtonWithTitle:NSLocalizedString(
                                        [self valuesTitlesKeys][APPSPushSettingValueAll], nil)];
    [actionSheet
        addButtonWithTitle:NSLocalizedString([self valuesTitlesKeys][APPSPushSettingValueFollowing],
                                             nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(
                                        [self valuesTitlesKeys][APPSPushSettingValueOff], nil)];
  }
  [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
  actionSheet.cancelButtonIndex = isOnOff ? 2 : 3;
  actionSheet.tag = setting;
  return actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex != actionSheet.cancelButtonIndex) {
    APPSPushSettingValue value;
    if ([self isOnOffSetting:actionSheet.tag]) {
      value =
          [[self onOffValuesTitlesKeys] indexOfObject:[actionSheet buttonTitleAtIndex:buttonIndex]];
    } else {
      value = [[self valuesTitlesKeys] indexOfObject:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
    [self setValue:value forSetting:actionSheet.tag];
    [self saveSettings];
  }
}

@end
