//
//  APPSUpdateUserRequest.m
//  Wazere
//
//  Created by iOS Developer on 9/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSUpdateUserRequest.h"

@implementation APPSUpdateUserRequest

- (APPSCurrentUser *)mapResponse:(NSDictionary *)obj {
  NSError *error;

  APPSCurrentUser *currentUser =
      [GRTJSONSerialization mergeObjectForEntityName:NSStringFromClass([APPSCurrentUser class])
                                  fromJSONDictionary:obj
                              inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                               error:&error];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

  return currentUser;
}

@end
