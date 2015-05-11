//
//  APPSTwitterUtility.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSTwitterUtility.h"
#import "APPSPhotoModel.h"
#import <STTwitter.h>
#import <STTwitterOAuth.h>

#import "APPSTwitterAuthViewController.h"
#import "APPSTabBarViewController.h"
#import "APPSPhotoImageView.h"

@interface APPSTwitterUtility () <UIActionSheetDelegate, UIWebViewDelegate>
@property(copy, nonatomic) dispatch_block_t completionHandler;
@property(copy, nonatomic) dispatch_block_t errorHandler;
@property(strong, nonatomic) STTwitterAPI *twitterAPIOS;
@property(strong, nonatomic) STTwitterOAuth *oauth;
@property(strong, nonatomic) UIActionSheet *accountActionSheet;
@property(strong, nonatomic) ACAccountStore *accountStore;
@end

@implementation APPSTwitterUtility

static NSString *const TwitterApplicationName = @"Wazere";
static NSString *const TwitterConsumerKey = @"qdfu3QSv1UKoMjoq7BCwML7lK";
static NSString *const TwitterConsumerSecret =
    @"XtdA8B2jwPkE8hh0wlXF9vkc44u0BLaSECXF4kTdElzvJM9NbR";
static NSString *const callback = @"http://example.com";

- (BOOL)isAuthorized {
  return self.twitterAPIOS != nil;
}

#pragma mark - Authorizing account using settings

- (void)authorizeTwitterWithUsersAccount:(ACAccount *)account {
  self.twitterAPIOS = [STTwitterAPI twitterAPIOSWithAccount:account];
  [self verifyTwitterCredentials];
}

- (void)verifyTwitterCredentials {
  STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:TwitterApplicationName
                                                            consumerKey:TwitterConsumerKey
                                                         consumerSecret:TwitterConsumerSecret];

  @weakify(self);
  [twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
      @strongify(self);
      [self.twitterAPIOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
          if (![self.twitterAPIOS respondsToSelector:@selector(oauthAccessToken)]) {
            [self.twitterAPIOS
                postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID,
                               NSString *screenName) { self.completionHandler(); }
                errorBlock:^(NSError *error) {
                    self.errorHandler();
                    NSLog(@"%@", error);
                }];

          } else {
            self.completionHandler();
          }
      } errorBlock:^(NSError *error) {
          self.errorHandler();
          NSLog(@"%@", error);
      }];
  } errorBlock:^(NSError *error) {
      @strongify(self);
      self.errorHandler();
      NSLog(@"%@", error);
  }];
}

- (void)getTwitterAccountFromSettings {
  self.accountStore = [[ACAccountStore alloc] init];
  ACAccountType *accountType =
      [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  @weakify(self);
  [self.accountStore
      requestAccessToAccountsWithType:accountType
                              options:nil
                           completion:^(BOOL granted, NSError *error) {
                               @strongify(self);
                               if (granted) {
                                 NSArray *accounts =
                                     [self.accountStore accountsWithAccountType:accountType];
                                 if (accounts.count) {
                                   if (accounts.count > 1) {
                                     NSMutableArray *titles = [[NSMutableArray alloc] init];
                                     for (ACAccount *account in accounts) {
                                       [titles addObject:account.username];
                                     }
                                     [self showActionSheetWithTitles:titles];
                                   } else {
                                     [self authorizeTwitterWithUsersAccount:[accounts firstObject]];
                                   }
                                 } else {
                                   [self authorizeTwitterUsingWeb];
                                 }
                               } else {
                                 [self authorizeTwitterUsingWeb];
                               }
                           }];
}

#pragma mark - Twitter Accounts ActionSheet

- (void)showActionSheetWithTitles:(NSArray *)titles {
  for (NSString *title in titles) {
    [self.accountActionSheet addButtonWithTitle:title];
  }

  dispatch_async(dispatch_get_main_queue(), ^{
      [self.accountActionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
  });
}

- (UIActionSheet *)accountActionSheet {
  if (!_accountActionSheet) {
    _accountActionSheet =
        [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Chose twitter account", nil)
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                      destructiveButtonTitle:nil
                           otherButtonTitles:nil];
  }
  return _accountActionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
  self.accountStore = [[ACAccountStore alloc] init];
  ACAccountType *accountType =
      [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
  if (buttonIndex) {
    [self authorizeTwitterWithUsersAccount:accounts[buttonIndex - 1]];
  } else {
    self.errorHandler();
  }
}

#pragma mark - Authorizing account using WEB

- (void)authorizeTwitterUsingWeb {
  self.oauth = [STTwitterOAuth twitterOAuthWithConsumerName:TwitterApplicationName
                                                consumerKey:TwitterConsumerKey
                                             consumerSecret:TwitterConsumerSecret];

  @weakify(self);
  [self.oauth postTokenRequest:^(NSURL *url, NSString *oauthToken) {
      @strongify(self);
      [self openWebViewWithUrl:url];
  } oauthCallback:callback
      errorBlock:^(NSError *error){}];
}

- (void)openWebViewWithUrl:(NSURL *)url {
  APPSTwitterAuthViewController *twitterAuth = [[APPSTwitterAuthViewController alloc] init];
  UIViewController *rootViewController = [APPSTabBarViewController rootViewController];

  if (rootViewController.presentedViewController.presentedViewController) {
    rootViewController =
        rootViewController.presentedViewController.presentedViewController.presentedViewController;
  }

  [rootViewController
      presentViewController:twitterAuth
                   animated:YES
                 completion:^{
                     twitterAuth.webView.delegate = self;
                     [twitterAuth.webView loadRequest:[NSURLRequest requestWithURL:url]];
                 }];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if ([[[request URL] absoluteString] hasPrefix:callback]) {
    UIViewController *rootViewController = [APPSTabBarViewController rootViewController];

    if (rootViewController.presentedViewController.presentedViewController) {
      rootViewController = rootViewController.presentedViewController.presentedViewController
                               .presentedViewController;
    }
    [rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *params = [self paramsFromUrl:[request URL]];
    [self sendAccessToken:params[@"oauth_verifier"]];
    return NO;
  }
  return YES;
}

- (NSDictionary *)paramsFromUrl:(NSURL *)url {
  NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
  NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"&"];

  for (NSString *keyValuePair in urlComponents) {
    NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
    NSString *key = pairComponents[0];
    NSString *value = pairComponents[1];

    queryStringDictionary[key] = value;
  }
  return queryStringDictionary;
}

- (void)sendAccessToken:(NSString *)oauth_verifier {
  @weakify(self);
  [self.oauth postAccessTokenRequestWithPIN:oauth_verifier
      successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID,
                     NSString *screenName) {
          @strongify(self);
          self.twitterAPIOS = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TwitterConsumerKey
                                                            consumerSecret:TwitterConsumerSecret
                                                                oauthToken:oauthToken
                                                          oauthTokenSecret:oauthTokenSecret];

          [self verifyTwitterCredentials];
      }
      errorBlock:^(NSError *error) { NSLog(@"%@", error); }];
}

#pragma mark - Authorizing

- (void)authorizeCurrentUser {
  if (!self.twitterAPIOS) {
    @weakify(self);
    self.completionHandler = ^{
        @strongify(self);
        [self photoSharedSuccessfully:self.twitterAPIOS != nil completion:NULL];
    };
    self.errorHandler = ^{
        @strongify(self);
        [self photoSharedSuccessfully:NO completion:NULL];
    };

    [self getTwitterAccountFromSettings];
  }
}

#pragma mark - Publishing photo

- (void)authorizeAndPublishPhoto:(APPSPhotoModel *)photoModel
                      completion:(TwitterShareCompletion)completion {
  @weakify(self);
  self.completionHandler = ^{
      @strongify(self);
      [self publishPhotoToTwitter:photoModel completion:completion];
  };
  self.errorHandler = ^{
      @strongify(self);
      [self photoSharedSuccessfully:NO completion:completion];
  };

  if (self.twitterAPIOS) {
    self.completionHandler();
  } else {
    [self getTwitterAccountFromSettings];
  }
}

- (void)publishPhotoToTwitter:(APPSPhotoModel *)photoModel
                   completion:(TwitterShareCompletion)completion {
  if (photoModel.blurredImage) {
    [self postTwitterStatusUpdateWithImage:photoModel.blurredImage
                                photoModel:photoModel
                                completion:completion];
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSTwitterUtility"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Blurred image is nil"
                                 }]);
    [self photoSharedSuccessfully:NO completion:completion];
  }
}

- (void)postTwitterStatusUpdateWithImage:(UIImage *)image
                              photoModel:(APPSPhotoModel *)photoModel
                              completion:(TwitterShareCompletion)completion {
  [[APPSUtilityFactory sharedInstance].backgroundTaskManager beginNewBackgroundTask];
  BOOL location = photoModel.photoLatitude && photoModel.photoLongitude;
  [self.twitterAPIOS
      postStatusUpdate:[photoModel.photoDescription
                           stringByAppendingString:@"\n\nDiscover this photo on @WazereApp\n"]
      mediaDataArray:@[ UIImagePNGRepresentation(image) ]
      possiblySensitive:nil
      inReplyToStatusID:nil
   latitude:location ? [NSString stringWithFormat:@"%f", [photoModel.photoLatitude floatValue]] : nil
   longitude:location ? [NSString stringWithFormat:@"%f", [photoModel.photoLongitude floatValue]] : nil
      placeID:nil
      displayCoordinates:nil
      uploadProgressBlock:nil
      successBlock:^(NSDictionary *status) {
          [self photoSharedSuccessfully:YES completion:completion];
      }
      errorBlock:^(NSError *error) {
          NSLog(@"Error posting to twitter %@", error);
          [self photoSharedSuccessfully:NO completion:completion];
      }];
}

- (void)logOut {
  self.twitterAPIOS = nil;
}

- (void)photoSharedSuccessfully:(BOOL)success completion:(TwitterShareCompletion)completion {
  [[NSNotificationCenter defaultCenter] postNotificationName:photoUploadingFinishedNotification
                                                      object:@(success)];
  if (!success) {
    [[[UIAlertView alloc]
            initWithTitle:NSLocalizedString(@"Publishing failed", nil)
                  message:NSLocalizedString(@"Can't upload photo to twitter, please try again", nil)
                 delegate:nil
        cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
        otherButtonTitles:nil] show];
  }
  if (completion) {
    completion(success);
  }
}

@end
