//
//  APPSTwitterUtility.h
//  Wazere
//
//  Created by Gaidax on 11/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TwitterShareCompletion)(BOOL success);

@interface APPSTwitterUtility : NSObject
- (BOOL)isAuthorized;
- (void)authorizeAndPublishPhoto:(APPSPhotoModel *)photoModel
                      completion:(TwitterShareCompletion)completion;
- (void)logOut;
- (void)photoSharedSuccessfully:(BOOL)success completion:(TwitterShareCompletion)completion;
- (void)authorizeCurrentUser;
@end
