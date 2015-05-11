//
//  APPSSettingsConstants.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSSettingsConstants_h
#define Wazere_APPSSettingsConstants_h

static NSString *const kSettingsViewCell = @"SettingsTableCell";
static NSString *const kPushNotificationsTableViewCell = @"PushNotificationsTableViewCell";
static NSString *const kSearchSegue = @"SearchSegue";
static NSString *const kSearchFacebookFriendsSegue = @"SearchFacebokSegue";
static NSString *const kPushNotificationsSettingsSegue = @"PushNotificationsSettingsSegue";
static NSString *const kPrivacyPolicySettingSegue = @"PrivacyPolicySegue";
static NSString *const kTermsOfServiceSettingSegue = @"TermsOfServiceSegue";

static CGFloat const PushNotificationsCellHeight = 48.f;
static CGFloat const WideScreenLogOutOffset = 150.f;
static CGFloat const LogOutCellOffset = 62.f;
static CGFloat const DefaultDistanceBetweenCells = 7.f;

static NSString *const kSettingsKeyPath = @"users/%@/settings";

#endif
