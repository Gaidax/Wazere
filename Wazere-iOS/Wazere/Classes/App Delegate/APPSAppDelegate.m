//
//  AppDelegate.m
//  Wazere
//
//  Created by iOS Developer on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAppDelegate.h"
#import <iRate.h>
#import "GAI.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface APPSAppDelegate () <UIAlertViewDelegate>

@end

@implementation APPSAppDelegate

+ (void)initialize {
  [self configureRateLibrary];
}

+ (APPSAppDelegate *)sharedInstance {
  return (APPSAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Fabric with:@[CrashlyticsKit]];
  [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Wazere.sqlite"];

  [self setupNetworkManagers];
  [self registerApplicationForNotifications];
  [self setupGoogleAnalytics];
  [self configureNotificationWindow];
  [self checkIfFirstLoad];
  NSInteger memoryCost = 25, imageDimensions = 640;
  [[SDImageCache sharedImageCache] setMaxMemoryCost:memoryCost * imageDimensions * imageDimensions];

  [[APPSUtilityFactory sharedInstance].notificationUtility setUpUpNotificationUtilityWithLaunchOptions:launchOptions];
    

  return YES;
}

- (void)registerApplicationForNotifications {
  UIApplication *application = [UIApplication sharedApplication];
  if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
    [application registerForRemoteNotifications];
    [application
        registerUserNotificationSettings:[UIUserNotificationSettings
                                             settingsForTypes:(UIUserNotificationTypeSound |
                                                               UIUserNotificationTypeAlert |
                                                               UIUserNotificationTypeBadge)
                                                   categories:nil]];
  } else {
    [application registerForRemoteNotificationTypes:(UIUserNotificationTypeSound |
                                                     UIUserNotificationTypeAlert |
                                                     UIUserNotificationTypeBadge)];
  }
}

- (void)setupLocationManager {
  [[[APPSUtilityFactory sharedInstance] locationUtility] startStandardUpdatesWithDesiredAccuracy:kCLLocationAccuracyBestForNavigation distanceFilter:5 handler:^(CLLocation *location, NSError *error) {
      [[[APPSUtilityFactory sharedInstance] locationUtility] stopUpdates];
  }];
}

- (void)setupNetworkManagers {
  [[AFNetworkActivityLogger sharedLogger] startLogging];
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  [[AFNetworkReachabilityManager sharedManager]
      setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
          if (status < AFNetworkReachabilityStatusReachableViaWWAN) {
            UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:nil
                          message:NSLocalizedString(@"No Internet Connection. Please check "
                                                    @"your network settings",
                                                    nil)
                         delegate:nil
                cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                otherButtonTitles:nil];
            [alert show];
          }
      }];
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)setupGoogleAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-57807709-1"];
}

- (void)configureNotificationWindow {
    CGRect windowFrame = self.window.frame;
    windowFrame.size.height = 60;
    self.notificationWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    self.notificationWindow.backgroundColor = [UIColor clearColor];
    self.notificationWindow.windowLevel = UIWindowLevelStatusBar;
    self.notificationWindow.hidden = YES;
    self.notificationWindow.userInteractionEnabled = NO;
}

- (void)checkIfFirstLoad {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kIsFirstLoadKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstLoadKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsFirstLoadKey];
        [self setupLocationManager];
    }
}

+ (void)configureRateLibrary {
  iRate *rate = [iRate sharedInstance];
  //    rate.applicationBundleID = @"com.aedima.toonight";
  //    rate.previewMode = YES;
  rate.verboseLogging = NO;
  rate.daysUntilPrompt = 5;
  rate.remindPeriod = 2;
  rate.message = NSLocalizedString(@"Do you love Wazere? Rate us in the App Store!", nil);
  rate.rateButtonLabel = NSLocalizedString(@"Rate it now", nil);
  rate.remindButtonLabel = NSLocalizedString(@"Remind me later", nil);
  rate.cancelButtonLabel = NSLocalizedString(@"Don't show this again", nil);
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
  [FBAppCall handleDidBecomeActive];
  [[[APPSUtilityFactory sharedInstance] notificationUtility] updateUserSession];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the
  // application terminates.
  [self saveContext];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
  if ([[[APPSUtilityFactory sharedInstance] facebookUtility] handler] == NULL) {
    [FBSession.activeSession
        setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [[[APPSUtilityFactory sharedInstance] facebookUtility] sessionStateChanged:session
                                                                                 state:state
                                                                                 error:error];
            if (state == FBSessionStateOpen || state == FBSessionStateOpenTokenExtended) {
              [[FBSession activeSession] closeAndClearTokenInformation];
            }
        }];
  }
  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
  return NO;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
  return NO;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  APPSNotificationUtility *utility = [[APPSUtilityFactory sharedInstance] notificationUtility];
  utility.deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    APPSNotificationUtility *utility = [APPSUtilityFactory sharedInstance].notificationUtility;
    [utility updateNotificationWithUserInfo:userInfo];
}

- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  [application registerForRemoteNotifications];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:NULL];
}

@end
