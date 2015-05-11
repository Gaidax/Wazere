//
//  AppDelegate.h
//  Wazere
//
//  Created by iOS Developer on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface APPSAppDelegate : UIResponder<UIApplicationDelegate>

@property(strong, NS_NONATOMIC_IOSONLY) UIWindow *window;
@property(strong, NS_NONATOMIC_IOSONLY) UIWindow *notificationWindow;

- (void)saveContext;

+ (APPSAppDelegate *)sharedInstance;

@end
