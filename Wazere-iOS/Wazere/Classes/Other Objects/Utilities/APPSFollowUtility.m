//
//  APPSFollowUtility.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFollowUtility.h"
#import "APPSSomeUser.h"
#import "APPSFollowCommand.h"

@implementation APPSFollowUtility

- (void)followUser:(APPSSomeUser *)user
    withCompletionHandler:(CompletionHandler)completionHandler
             errorHandler:(ErrorHandler)errorHandler {
  [self startFollowRequestWithUser:user
                                         method:HTTPMethodPOST
                              completionHandler:completionHandler
                                   errorHandler:errorHandler];
}

- (void)unFollowUser:(APPSSomeUser *)user
    withCompletionHandler:(CompletionHandler)completionHandler
             errorHandler:(ErrorHandler)errorHandler {
  [self startFollowRequestWithUser:user
                                         method:HTTPMethodDELETE
                              completionHandler:completionHandler
                                   errorHandler:errorHandler];
}

- (void)startFollowRequestWithUser:(APPSSomeUser *)user
                            method:(NSString *)method
                 completionHandler:(CompletionHandler)completionHandler
                      errorHandler:(ErrorHandler)errorHandler {
  APPSCurrentUser *currentuser = [[APPSCurrentUserManager sharedInstance] currentUser];

  APPSRACBaseRequest *request = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              params:@{
                @"other_user_id" : user.userId
              }
              method:method
             keyPath:[NSString stringWithFormat:KeyPathFollowUser, currentuser.userId]
          disposable:nil];
  [self updateFollowStatusAndPostNotificationForUser:user];
  @weakify(self);
    [request.execute subscribeNext:^(NSDictionary *response) {
      if (completionHandler) {
        completionHandler(response);
      }
  }
                           error:^(NSError *error) {
                             @strongify(self);
                             [self updateFollowStatusAndPostNotificationForUser:user];
                             if (errorHandler) {
                               errorHandler(error);
                             }
                             NSHTTPURLResponse *response =  (NSHTTPURLResponse *)error.userInfo[kWebAPIErrorKey];
                             if ([response statusCode] == HTTPStausCodeBadParams) {
                               NSString *message = (NSString *)error.userInfo[kWebAPIErrorResponseKey];
                               if (message.length) {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(message, nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                                 [alert show];
                               }
                             }
                           }];
}

- (void)followUsers:(NSArray *)usersIds
    withCompletionHandler:(CompletionHandler)completionHandler
             errorHandler:(ErrorHandler)errorHandler {
    APPSCurrentUser *currentuser = [[APPSCurrentUserManager sharedInstance] currentUser];
    
    APPSRACBaseRequest *request = [[APPSFollowCommand alloc]
                                   initWithObject:nil
                                   params:@{
                                            @"user_ids" : usersIds
                                            }
                                   method:HTTPMethodPOST
                                   keyPath:[NSString stringWithFormat:KeyPathFollowAllUsers, currentuser.userId]
                                   disposable:nil];
    [request.execute subscribeNext:^(NSDictionary *response) {
      if (completionHandler) {
        completionHandler(response);
      }
    }
                             error:^(NSError *error) {
                               if (errorHandler) {
                                 errorHandler(error);
                               }
                             }];
}

- (NSNumber *)followersCountAtFollowOperationForUser:(APPSSomeUser *)user {
  if ([user.isFollowed boolValue]) {
    return @(user.followersCount.intValue - 1);
  } else {
    return @(user.followersCount.intValue + 1);
  }
}

- (void)changeFollowStatusAtUser:(APPSSomeUser *)user {
  user.followersCount = [self followersCountAtFollowOperationForUser:user];
  user.isFollowed = @(![user.isFollowed boolValue]);
}

- (void)updateFollowStatusAndPostNotificationForUser:(APPSSomeUser *)user {
  [self changeFollowStatusAtUser:user];
  NSNumber *following = [[[APPSCurrentUserManager sharedInstance] currentUser] followingCount];
  NSInteger updatedFollowing =
  [user.isFollowed boolValue] ? [following integerValue] + 1 : [following integerValue] - 1;
  if (updatedFollowing < 0) {
    updatedFollowing = 0;
    NSLog(@"%@", [NSError errorWithDomain:@"APPSProfileViewControllerDelegate"
                                     code:8
                                 userInfo:@{
                                            NSLocalizedFailureReasonErrorKey : @"Invalid following count"
                                            }]);
  }
  [[[APPSCurrentUserManager sharedInstance] currentUser] setFollowingCount:@(updatedFollowing)];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserNotificationName
                                                      object:self
                                                    userInfo:@{kUpdateUserNotificationKey : user}];
}

@end 
