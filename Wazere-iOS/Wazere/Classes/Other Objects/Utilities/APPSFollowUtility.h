//
//  APPSFollowUtility.h
//  Wazere
//
//  Created by Gaidax on 10/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPSSomeUser;

typedef void (^CompletionHandler)(NSDictionary *response);
typedef void (^ErrorHandler)(NSError *error);

@interface APPSFollowUtility : NSObject

- (void)followUser:(APPSSomeUser *)user
    withCompletionHandler:(CompletionHandler)completionHandler
             errorHandler:(ErrorHandler)errorHandler;
- (void)unFollowUser:(APPSSomeUser *)user
    withCompletionHandler:(CompletionHandler)completionHandler
             errorHandler:(ErrorHandler)errorHandler;
- (void)startFollowRequestWithUser:(APPSSomeUser *)user
                            method:(NSString *)method
                 completionHandler:(CompletionHandler)completionHandler
                      errorHandler:(ErrorHandler)errorHandler;
- (void)followUsers:(NSArray *)usersIds
    withCompletionHandler:(CompletionHandler)completionHandler
             errorHandler:(ErrorHandler)errorHandler;
- (void)updateFollowStatusAndPostNotificationForUser:(APPSSomeUser *)user;
@end
