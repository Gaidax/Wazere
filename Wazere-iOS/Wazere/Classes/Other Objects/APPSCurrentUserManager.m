//
//  APPSCurrentUserManager.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCurrentUserManager.h"

@implementation APPSCurrentUserManager

+ (APPSCurrentUserManager *)sharedInstance {
  static APPSCurrentUserManager *manager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ manager = [[APPSCurrentUserManager alloc] init]; });

  return manager;
}

- (APPSCurrentUser *)currentUser {
  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"userId == %@",
                          [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserIdKey]];
  return (APPSCurrentUser *)[APPSCurrentUser MR_findFirstWithPredicate:predicate];
}

@end