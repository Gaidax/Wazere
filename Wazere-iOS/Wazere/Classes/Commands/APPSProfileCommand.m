//
//  APPSProfieCommand.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileCommand.h"
#import "APPSSomeUser.h"

@implementation APPSProfileCommand

- (id)mapResponse:(NSDictionary *)responseObject {
  NSError *error;
  id<APPSUserProtocol> user =
      [[APPSSomeUser alloc] initWithDictionary:responseObject[@"user"] error:&error];
  if (user == nil) {
    NSLog(@"%@", error);
    return nil;
  }
  if ([[[[APPSCurrentUserManager sharedInstance] currentUser] userId] unsignedIntegerValue] ==
      [user.userId unsignedIntegerValue]) {
    user = [GRTJSONSerialization mergeObjectForEntityName:NSStringFromClass([APPSCurrentUser class])
                                       fromJSONDictionary:responseObject
                                   inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                    error:&error];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    if (user == nil) {
      NSLog(@"%@", error);
    }
  }
  return user;
}

@end
