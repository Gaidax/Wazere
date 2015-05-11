//
//  APPSMultipartCommand.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/6/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMultipartCommand.h"

@implementation APPSMultipartCommand

- (void)processResponse:(NSHTTPURLResponse *)response {
  NSUserDefaults *defaultsDB = [NSUserDefaults standardUserDefaults];
  NSString *token = [response allHeaderFields][kSessionTokenKey];
  [defaultsDB setObject:token forKey:kSessionTokenKey];
}

- (id)mapResponse:(id)obj {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSError *error = nil;
  NSManagedObject *currentUser =
      [GRTJSONSerialization mergeObjectForEntityName:NSStringFromClass([APPSCurrentUser class])
                                  fromJSONDictionary:obj
                              inManagedObjectContext:context
                                               error:&error];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
  return currentUser;
}

@end
