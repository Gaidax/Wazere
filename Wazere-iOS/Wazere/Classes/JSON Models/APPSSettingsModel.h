//
//  APPSSettingsModel.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

typedef NS_ENUM(NSInteger, APPSPushSettingValue) {
  APPSPushSettingValueOff,
  APPSPushSettingValueAll,
  APPSPushSettingValueFollowing
};

@interface APPSSettingsModel : APPSBaseModel

@property(assign, nonatomic) APPSPushSettingValue facebookFriends;
@property(assign, nonatomic) APPSPushSettingValue likes;
@property(assign, nonatomic) APPSPushSettingValue followers;
@property(assign, nonatomic) APPSPushSettingValue comments;
@property(assign, nonatomic) APPSPushSettingValue directActivity;

@end
