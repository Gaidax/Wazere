//
//  UtilityFactory.m
//  flocknest
//
//  Created by iOS Developer on 2/28/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import "APPSUtilityFactory.h"

@interface APPSUtilityFactory ()

@property(strong, NS_NONATOMIC_IOSONLY) NSMutableDictionary *utilities;

@end

@implementation APPSUtilityFactory

- (instancetype)init {
  self = [super init];
  if (self) {
    self.utilities = [NSMutableDictionary new];
  }
  return self;
}

+ (APPSUtilityFactory *)sharedInstance {
  static APPSUtilityFactory *utilities;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ utilities = [APPSUtilityFactory new]; });
  return utilities;
}

- (id)utilityFromPool:(Class)utilityClass {
  NSString *className = NSStringFromClass(utilityClass);
  id utility = self.utilities[className];
  if (![utility isKindOfClass:utilityClass]) {
    if (utility == nil) {
      utility = [utilityClass new];
      self.utilities[className] = utility;
    } else {
      NSLog(@"%@", [NSError errorWithDomain:@"APPSUtilityFactory"
                                       code:0
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"Wrong utility"
                                   }]);
      return nil;
    }
  }
  return utility;
}

- (APPSFacebookUtility *)facebookUtility {
  APPSFacebookUtility *facebookUtility = [self utilityFromPool:[APPSFacebookUtility class]];
  return facebookUtility;
}

- (APPSImageUtility *)imageUtility {
  APPSImageUtility *utility = [self utilityFromPool:[APPSImageUtility class]];
  return utility;
}

- (APPSMapBlurCircleUtility *)mapBlurUtility {
  APPSMapBlurCircleUtility *utility = [self utilityFromPool:[APPSMapBlurCircleUtility class]];
  return utility;
}

- (APPSCollectionViewButtonsFactory *)buttonsFactory {
  APPSCollectionViewButtonsFactory *factory =
      [self utilityFromPool:[APPSCollectionViewButtonsFactory class]];
  return factory;
}

- (APPSLocationManagerUtility *)locationUtility {
  APPSLocationManagerUtility *utility = [self utilityFromPool:[APPSLocationManagerUtility class]];
  return utility;
}

- (APPSLeftBarButtonsUtility *)leftBarButtonsUtility {
  APPSLeftBarButtonsUtility *utility = [self utilityFromPool:[APPSLeftBarButtonsUtility class]];
  return utility;
}

- (APPSNotificationUtility *)notificationUtility {
  APPSNotificationUtility *utility = [self utilityFromPool:[APPSNotificationUtility class]];
  return utility;
}

- (APPSTwitterUtility *)twitterUtility {
  APPSTwitterUtility *utility = [self utilityFromPool:[APPSTwitterUtility class]];
  return utility;
}

- (APPSHotWordsUtility *)hotWordsUtility {
  APPSHotWordsUtility *utility = [self utilityFromPool:[APPSHotWordsUtility class]];
  return utility;
}

- (APPSBackgroundTaskManager *)backgroundTaskManager {
  APPSBackgroundTaskManager *manager = [self utilityFromPool:[APPSBackgroundTaskManager class]];
  return manager;
}

- (APPSProfileBackgroundViewUtility *)profileBackgroundUtility {
  APPSProfileBackgroundViewUtility *utility = [self utilityFromPool:[APPSProfileBackgroundViewUtility class]];
  return utility;
}

- (APPSFollowUtility *)followUtility {
  APPSFollowUtility *followUtility = [self utilityFromPool:[APPSFollowUtility class]];
  return followUtility;
}

@end
