//
//  UtilityFactory.h
//  flocknest
//
//  Created by iOS Developer on 2/28/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSFacebookUtility.h"
#import "APPSImageUtility.h"
#import "APPSMapBlurCircleUtility.h"
#import "APPSCollectionViewButtonsFactory.h"
#import "APPSLocationManagerUtility.h"
#import "APPSLeftBarButtonsUtility.h"
#import "APPSNotificationUtility.h"
#import "APPSTwitterUtility.h"
#import "APPSHotWordsUtility.h"
#import "APPSBackgroundTaskManager.h"
#import "APPSProfileBackgroundViewUtility.h"
#import "APPSFollowUtility.h"

@interface APPSUtilityFactory : NSObject

+ (APPSUtilityFactory *)sharedInstance;

@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSFacebookUtility *facebookUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSImageUtility *imageUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSMapBlurCircleUtility *mapBlurUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSCollectionViewButtonsFactory *buttonsFactory;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSLocationManagerUtility *locationUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSLeftBarButtonsUtility *leftBarButtonsUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSNotificationUtility *notificationUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSTwitterUtility *twitterUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSHotWordsUtility *hotWordsUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSBackgroundTaskManager *backgroundTaskManager;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSProfileBackgroundViewUtility *profileBackgroundUtility;
@property(strong, NS_NONATOMIC_IOSONLY, readonly) APPSFollowUtility *followUtility;

@end
