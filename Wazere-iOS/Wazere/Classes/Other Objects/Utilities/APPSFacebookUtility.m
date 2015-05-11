//
//  APPSFacebookUtility.m
//  Wazere
//
//  Created by iOS Developer on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFacebookUtility.h"
#import "APPSPhotoModel.h"
#import "APPSPhotoImageView.h"
#import "APPSBackgroundTaskManager.h"

@implementation APPSFacebookUtility

static NSString *const FacebookAppLink = @"https://fb.me/242206425950006";

- (void)showMessage:(NSString *)message withTitle:(NSString *)title {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                        otherButtonTitles:nil];
  [alert show];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error {
  // If the session was opened successfully
  if (!error && state == FBSessionStateOpen) {
    NSLog(@"Session opened");
    // Show the user the logged-in UI
    if (self.handler) {
      self.handler([FBSession activeSession].accessTokenData.accessToken, nil);
    }
    return;
  }
  if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
    // If the session is closed
    NSLog(@"Session closed");
    // Show the user the logged-out UI
    if (self.handler) {
      self.handler(nil, nil);
    }
  }
  [self handleError:error withState:state];
}

- (void)handleError:(NSError *)error withState:(FBSessionState)state {
  // Handle errors
  if (error) {
    NSLog(@"Error");
    NSString *alertText;
    NSString *alertTitle;
    // If the error requires people using an app to make an action outside of
    // the app in order to recover
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
      alertTitle = NSLocalizedString(@"Something went wrong", nil);
      alertText = [FBErrorUtility userMessageForError:error];
      [self showMessage:alertText withTitle:alertTitle];
    } else {
      // If the user cancelled login, do nothing
      if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"User cancelled login");

        // Handle session closures that happen outside of the app
      } else if ([FBErrorUtility errorCategoryForError:error] ==
                 FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = NSLocalizedString(@"Session Error", nil);
        alertText = NSLocalizedString(
            @"Your current session is no longer valid. Please log in again.", nil);
        [self showMessage:alertText withTitle:alertTitle];

        // Here we will handle all other errors with a generic error message.
        // We recommend you check our Handling Errors guide for more information
        // https://developers.facebook.com/docs/ios/errors/
      } else {
        // Get more error information from the error
        NSDictionary *errorInformation =
            (error.userInfo)[@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"];

        // Show the user an error message
        alertTitle = NSLocalizedString(@"Something went wrong", nil);
        alertText = [NSString
            stringWithFormat:NSLocalizedString(@"Please retry. \n\n If the problem persists "
                                               @"contact us and mention this error code: %@",
                                               nil),
                             errorInformation[@"message"]];
        [self showMessage:alertText withTitle:alertTitle];
      }
    }
    [self finishingHandleError:error withState:state];
  }
}

- (void)finishingHandleError:(NSError *)error withState:(FBSessionState)state {
  if (state == FBSessionStateOpen || state == FBSessionStateOpenTokenExtended) {
    // Clear this token
    [FBSession.activeSession closeAndClearTokenInformation];
  }
  // Show the user the logged-out UI
  if (self.handler) {
    self.handler(nil, error);
  }
}

- (void)openSessionWithHandler:(FacebookUtilityCompletion)handler {
  self.handler = handler;
  NSArray *permissions = @[ @"public_profile", @"email", @"user_friends", @"publish_actions" ];

  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    // If there's one, just open the session silently, without showing the user
    // the login UI
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:NO
                                  completionHandler:^(FBSession *session, FBSessionState state,
                                                      NSError *error) {
                                      // Handler for session state changes
                                      // This method will be called EACH time
                                      // the session state changes,
                                      // also for intermediate states and NOT
                                      // just when the session open
                                      [self sessionStateChanged:session state:state error:error];
                                  }];
  } else if (FBSession.activeSession.state == FBSessionStateOpen ||
             FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    if (handler) {
      handler([FBSession activeSession].accessTokenData.accessToken, nil);
    }
  } else {
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status,
                                                      NSError *error) {
                                      [self sessionStateChanged:session state:status error:error];
                                  }];
  }
}

- (void)clearSessionInfoAndRenewSystemCredentials {
  [FBSession.activeSession closeAndClearTokenInformation];
  [FBSession renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error){

  }];
}

#pragma mark - Publishing photo to Facebook timeline

- (void)sharePhoto:(APPSPhotoModel *)photoModel completion:(FacebookShareCompletion)completion {
  FBSession *session = [FBSession activeSession];
  if (session.isOpen) {
    [self checkPermissionsAndPostPhotoModel:photoModel completion:completion];
  } else {
    [self openSessionWithHandler:^(NSString *token, NSError *error) {
        if (token) {
          [self checkPermissionsAndPostPhotoModel:photoModel completion:completion];
        } else if (error) {
          [self photoFinishedSuccessfully:NO completion:completion];
          NSLog(@"%@", error);
        }
    }];
  }
}

- (void)checkPermissionsAndPostPhotoModel:(APPSPhotoModel *)photoModel
                               completion:(FacebookShareCompletion)completion {
  if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
    [self requestPublishPermissionsAndPostPhotoModel:photoModel completion:completion];
  } else {
    [self publishPhotoToFacebook:photoModel completion:completion];
  }
}

- (void)requestPublishPermissionsAndPostPhotoModel:(APPSPhotoModel *)photoModel
                                        completion:(FacebookShareCompletion)completion {
  [FBSession.activeSession
      requestNewPublishPermissions:@[ @"publish_actions" ]
                   defaultAudience:FBSessionDefaultAudienceFriends
                 completionHandler:^(FBSession *session, NSError *error) {
                     __block NSString *alertText;
                     __block NSString *alertTitle;
                     if (!error) {
                       if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] ==
                           NSNotFound) {
                         alertTitle = NSLocalizedString(@"Permission not granted", nil);
                         alertText = NSLocalizedString(
                             @"Your photo will not be published to Facebook.", nil);
                         [[[UIAlertView alloc] initWithTitle:alertTitle
                                                     message:alertText
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] show];
                         [self photoFinishedSuccessfully:NO completion:completion];
                       } else {
                         [self publishPhotoToFacebook:photoModel completion:completion];
                       }

                     } else {
                       [self photoFinishedSuccessfully:NO completion:completion];
                       NSLog(@"%@", error);
                     }
                 }];
}

- (void)publishPhotoToFacebook:(APPSPhotoModel *)photoModel
                    completion:(FacebookShareCompletion)completion {
  if (photoModel.blurredImage) {
    [self uploadPhotoToFacebook:photoModel.blurredImage
                withDescription:photoModel.photoDescription
                     completion:completion];
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSFacebookUtility"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Blurred image is nil"
                                 }]);
    [self photoFinishedSuccessfully:NO completion:completion];
  }
}

- (void)uploadPhotoToFacebook:(UIImage *)photo
              withDescription:(NSString *)description
                   completion:(FacebookShareCompletion)completion {
  FBRequest *request = [FBRequest requestForUploadPhoto:photo];
  if (description.length) {
    (request.parameters)[@"message"] = description;
  }
  FBRequestConnection *connection = [[FBRequestConnection alloc] init];

  [[APPSUtilityFactory sharedInstance].backgroundTaskManager beginNewBackgroundTask];
  [connection addRequest:request
       completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
           [self photoFinishedSuccessfully:!error completion:completion];
           if (error) {
             NSLog(@"Photo upload failed %@", error.userInfo);
           }
       }];

  [connection start];
}

- (void)photoFinishedSuccessfully:(BOOL)success completion:(FacebookShareCompletion)completion {
  [[NSNotificationCenter defaultCenter] postNotificationName:photoUploadingFinishedNotification
                                                      object:@(success)];
  if (!success) {
    [[[UIAlertView alloc]
            initWithTitle:NSLocalizedString(@"Publishing failed", nil)
                  message:NSLocalizedString(@"Can't upload photo to facebook, please try again",
                                            nil)
                 delegate:nil
        cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
        otherButtonTitles:nil] show];
  }

  if (completion) {
    completion(success);
  }
}

- (void)closeSession {
  [[FBSession activeSession] closeAndClearTokenInformation];
}

@end
