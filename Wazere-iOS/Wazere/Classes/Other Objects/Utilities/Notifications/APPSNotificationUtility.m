//
//  APPSNotificationUtility.m
//  Wazere
//
//  Created by Gaidax on 11/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNotificationUtility.h"
#import "APPSNotificationModel.h"

#import "APPSTabbarBubble.h"

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileSegueState.h"

#import "APPSShowProfilePhotoDelegate.h"
#import "APPSShowProfilePhotoConfigurator.h"

#import "APPSSomeUser.h"
#import "APPSPhotoModel.h"

#import "APPSRACBaseRequest.h"
#import "AGPushNoteView.h"

#import "APPSTabBarViewController.h"
#import "APPSNewsFeedViewControllerDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSNavigationViewController.h"

@implementation APPSNotificationUtility

static NSString *const kUpdateDeviceTokenKeyPath = @"users/%lu/token";
static NSString *const kLastNotificationDefaultsKey = @"LastNotificationDefaultsKey";

- (void)setUpUpNotificationUtilityWithLaunchOptions:(NSDictionary *)launchOptions {
  NSDictionary *userInfo =
      [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (userInfo) {
    [self updateNotificationWithUserInfo:userInfo];
    self.openedAppFromPush = YES;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *arhivedData = [defaults objectForKey:kLastNotificationDefaultsKey];
    self.lastNotification = [NSKeyedUnarchiver unarchiveObjectWithData:arhivedData];
  }
}

- (void)setDeviceToken:(NSData *)deviceToken {
  if (_deviceToken != deviceToken) {
    _deviceToken = deviceToken;
    [self updateUserSession];
  }
}

- (void)setLastNotification:(APPSNotificationModel *)lastNotification {
  _lastNotification = lastNotification;
  NSData *arhivedData = [NSKeyedArchiver archivedDataWithRootObject:lastNotification];
  [[NSUserDefaults standardUserDefaults] setObject:arhivedData forKey:kLastNotificationDefaultsKey];
}

- (void)updateUserSessionForUser:(APPSCurrentUser *)user {
  [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:CurrentUserIdKey];
  [self updateUserSession];
}

- (void)updateUserSession {
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
  if (!self.didSendDeviceToken && self.deviceToken && currentUser) {
    NSString *deviceTokenKeyPath =
        [NSString stringWithFormat:kUpdateDeviceTokenKeyPath,
                                   (unsigned long)[currentUser.userId unsignedIntegerValue]];
    APPSRACBaseRequest *request =
        [[APPSRACBaseRequest alloc] initWithObject:nil
                                            params:@{
                                              kDeviceTokenKey : self.deviceToken
                                            }
                                            method:HTTPMethodPUT
                                           keyPath:deviceTokenKeyPath
                                        disposable:nil];
    @weakify(self);
    [[request execute] subscribeCompleted:^{
        @strongify(self);
        self.didSendDeviceToken = YES;
    }];
  }
}

- (void)updateNotificationWithUserInfo:(NSDictionary *)userInfo {
  NSError *error = nil;
  UIApplication *application = [UIApplication sharedApplication];

  self.lastNotification = [[APPSNotificationModel alloc] initWithDictionary:userInfo error:&error];
  self.openedAppFromPush = application.applicationState == UIApplicationStateInactive;

  if (application.applicationState == UIApplicationStateActive) {
    [[NSNotificationCenter defaultCenter] postNotificationName:pushReceivedNotificationName
                                                        object:self.lastNotification];
    [self showBubbeView];
    [self showPushNote];
  }
}

- (UIViewController *)viewControllerForLastNotification {
  UIViewController *viewController = nil;
  if (self.lastNotification) {
    if ([self.lastNotification shouldLoadPhoto]) {
      if (self.lastNotification.photoId) {
        viewController = [self photoScreenViewControllerWithPhotoID:self.lastNotification.photoId];
      } else if ([self.lastNotification.photosIds count] == 1) {
        viewController = [self photoScreenViewControllerWithPhotoID:[self.lastNotification.photosIds firstObject]];
      }
    } else {
      viewController = [self profileScreenViewController];
    }
  }
  self.lastNotification = nil;
  return viewController;
}

- (UIViewController *)profileScreenViewController {
  APPSSomeUser *user = [[APPSSomeUser alloc] init];
  user.userId = self.lastNotification.userId;

  APPSProfileViewController *profileViewController =
      [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
          instantiateViewControllerWithIdentifier:@"APPSProfileViewController"];
  APPSProfileViewControllerDelegate *viewControllerDelegate =
      [[APPSProfileViewControllerDelegate alloc] initWithViewController:profileViewController
                                                                   user:user];
  APPSProfileViewControllerConfigurator *viewControllerConfigurator =
      [[APPSProfileViewControllerConfigurator alloc] init];

  profileViewController.configurator = viewControllerConfigurator;
  profileViewController.delegate = viewControllerDelegate;
  profileViewController.dataSource = viewControllerDelegate;
  profileViewController.state = [[APPSProfileSegueState alloc] init];

  return profileViewController;
}

- (UIViewController *)photoScreenViewControllerWithPhotoID:(NSNumber *)photoID {
  APPSPhotoModel *photo = [[APPSPhotoModel alloc] init];
  photo.photoId = [photoID unsignedIntegerValue];

  APPSProfileViewController *selectedPhotoController =
      [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
          instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  selectedPhotoController.configurator = [[APPSShowProfilePhotoConfigurator alloc] init];
  APPSShowProfilePhotoDelegate *delegate =
      [[APPSShowProfilePhotoDelegate alloc] initWithViewController:selectedPhotoController
                                                              user:nil
                                                     selectedPhoto:photo];
  selectedPhotoController.delegate = delegate;
  selectedPhotoController.dataSource = delegate;

  return selectedPhotoController;
}

- (void)resetNotifications {
  self.lastNotification = nil;

  APPSRACBaseRequest *request = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              method:HTTPMethodPUT
             keyPath:[NSString stringWithFormat:
                                   KeyPathBadgeReset,
                                   [[APPSCurrentUserManager sharedInstance] currentUser].userId]
          disposable:nil];
  [request.execute subscribeNext:^(NSDictionary *response){}];

  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - AGPushNoteView

- (void)showPushNote {
  [AGPushNoteView
      showWithNotificationMessage:[self.lastNotification.additionalParams valueForKey:@"alert"]];
  [AGPushNoteView setMessageAction:^(NSString *message) {
      if ([self isBubbleShown]) {
        [self hideBubbleView];
        APPSTabBarViewController *tabbarViewController =
            [APPSTabBarViewController rootViewController];
        UIViewController *viewController = tabbarViewController.viewControllers[newsFeedIndex];
        [tabbarViewController setSelectedViewController:viewController];
        APPSStrategyTableViewController *tableViewController =

            [((APPSNavigationViewController *)tabbarViewController.viewControllers[newsFeedIndex])
                    .viewControllers firstObject];
        APPSNewsFeedViewControllerDelegate *delegate =
            (APPSNewsFeedViewControllerDelegate *)((APPSStrategyTableViewController *)
                                                       tableViewController).delegate;
        [delegate reloadUsersListUsingFilter:@"mine"];
      }

  }];
}

#pragma mark - BubbleView Helpers

- (void)hideBubbleView {
  self.bubbleView.imageView.alpha = 0.f;
}

- (void)showBubbeView {
  [self.bubbleView showBubbleWithStyle:self.lastNotification.type];
}

- (BOOL)isBubbleShown {
  return self.bubbleView.imageView.alpha > 0.f;
}

@end
