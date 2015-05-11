//
//  APPSFacebookUtility.h
//  Wazere
//
//  Created by iOS Developer on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPSPhotoModel;
static NSString *const photoUploadingFinishedNotification = @"PhotoUploadingFinished";

typedef void (^FacebookUtilityCompletion)(NSString *token, NSError *error);
typedef void (^FacebookShareCompletion)(BOOL success);

@interface APPSFacebookUtility : NSObject

@property(copy, NS_NONATOMIC_IOSONLY) FacebookUtilityCompletion handler;

- (void)openSessionWithHandler:(FacebookUtilityCompletion)handler;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)sharePhoto:(APPSPhotoModel *)photoModel completion:(FacebookShareCompletion)completion;

- (void)closeSession;
@end
