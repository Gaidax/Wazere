//
//  APPSAuthCommand.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAuthCommand.h"

@implementation APPSAuthCommand

- (void)processResponse:(NSHTTPURLResponse *)response {
  NSUserDefaults *defaultsDB = [NSUserDefaults standardUserDefaults];
  [defaultsDB setObject:[response allHeaderFields][kSessionTokenKey] forKey:kSessionTokenKey];
}

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
