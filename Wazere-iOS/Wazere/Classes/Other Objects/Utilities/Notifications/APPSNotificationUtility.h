//
//  APPSNotificationUtility.h
//  Wazere
//
//  Created by Gaidax on 11/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

@class APPSNotificationModel;
@class APPSTabbarBubble;

static NSString *const pushReceivedNotificationName = @"APPSPushNotificationReceived";

@interface APPSNotificationUtility : NSObject
@property(strong, nonatomic) NSData *deviceToken;
@property(assign, nonatomic) BOOL didSendDeviceToken;
@property(strong, nonatomic) APPSNotificationModel *lastNotification;
@property(strong, nonatomic) APPSTabbarBubble *bubbleView;
@property(assign, nonatomic) BOOL isBubbleShown;
@property(assign, nonatomic) BOOL openedAppFromPush;

- (void)updateNotificationWithUserInfo:(NSDictionary *)userInfo;
- (UIViewController *)viewControllerForLastNotification;
- (void)showBubbeView;
- (void)hideBubbleView;
- (void)resetNotifications;
- (void)updateUserSession;
- (void)updateUserSessionForUser:(APPSCurrentUser *)user;
- (void)setUpUpNotificationUtilityWithLaunchOptions:(NSDictionary *)launchOptions;

@end
