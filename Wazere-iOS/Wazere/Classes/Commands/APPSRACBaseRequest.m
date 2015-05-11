//
//  APPSBaseRequest.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSRACBaseRequest.h"
#import "APPSSettingsViewControllerDelegate.h"

@interface APPSRACBaseRequest ()

@end

@implementation APPSRACBaseRequest

@synthesize method = _method, params = _params, keyPath = _keyPath, disposable = _disposable;

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (instancetype)initWithObject:(APPSBaseModel *)object
                        params:(NSDictionary *)params
                        method:(NSString *)method
                       keyPath:(NSString *)keyPath
                    disposable:(RACDisposable *)disposable {
  self = [self init];

  if (self) {
    if (object) {
      NSMutableDictionary *dict =
          [NSMutableDictionary dictionaryWithDictionary:[object serializable]];
      [dict addEntriesFromDictionary:params];
      _params = dict;
    } else if (params) {
      _params = params;
    }

    _params = [self updateParamsWithLocation:_params];

    _method = method;
    _keyPath = keyPath;
    if (disposable) {
      _disposable = disposable;
    } else {
      @weakify(self);
      _disposable = [RACDisposable disposableWithBlock:^{
          @strongify(self);
          [self cancel];
      }];
    }
  }

  return self;
}

- (NSMutableDictionary *)updateParamsWithLocation:(NSDictionary *)params {
  CLLocation *location = [[APPSUtilityFactory sharedInstance] locationUtility].currentLocation;
  NSMutableDictionary *dictionary = params ? [NSMutableDictionary dictionaryWithDictionary:params]
                                           : [[NSMutableDictionary alloc] init];
  if (location) {
    dictionary[@"latitude"] = @(location.coordinate.latitude);
    dictionary[@"longitude"] = @(location.coordinate.longitude);
  }

  return [dictionary copy];
}

- (instancetype)initWithObject:(id)object
                        method:(NSString *)method
                       keyPath:(NSString *)keyPath
                    disposable:(RACDisposable *)disposable {
  self =
      [self initWithObject:object params:nil method:method keyPath:keyPath disposable:disposable];

  if (self) {
  }

  return self;
}

- (RACSignal *)execute {
  @weakify(self);

  RACSignal *signal = [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {

      @strongify(self);

      NSMutableURLRequest *request = [self request];

      [self configureRequest:request];

      NSURLSession *session = [self session];

      NSURLSessionDataTask *task =
          [self dataTaskWithSession:session request:request subscriber:subscriber];
      self.dataTask = task;
      [self.dataTask resume];

      return self.disposable;

  }];
  return signal;
}

- (NSString *)createURLString {
  NSString *keyPath;
  if (self.keyPath) {
    keyPath = [kAPIVersion stringByAppendingPathComponent:self.keyPath];
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSRACBaseRequest"
                                     code:1
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Key path is nill"
                                 }]);
  }
  return keyPath;
}

- (NSMutableURLRequest *)request {
  NSString *keyPath = [self createURLString];
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
      requestWithMethod:self.method
              URLString:[[NSURL URLWithString:[keyPath stringByAddingPercentEscapesUsingEncoding:
                                                           NSUTF8StringEncoding]
                                relativeToURL:[NSURL URLWithString:BASE_URL_STRING]] absoluteString]
             parameters:self.params
                  error:nil];
  return request;
}

- (void)configureRequest:(NSMutableURLRequest *)request {
  NSUserDefaults *defaultsDB = [NSUserDefaults standardUserDefaults];
  [request setValue:[defaultsDB objectForKey:kSessionTokenKey] forHTTPHeaderField:kSessionTokenKey];
  [request setValue:@"iOS" forHTTPHeaderField:@"Device-Platform"];
  NSString *version =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  [request setValue:version forHTTPHeaderField:@"Build-Version"];
}

#pragma mark - Sesssions configuration

- (NSURLSession *)session {
  static NSURLSession *defaultSession = nil;
  if (defaultSession == nil) {
    NSURLSessionConfiguration *defaultConfiguration =
      [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfiguration.HTTPMaximumConnectionsPerHost = 1;
    defaultSession =
      [NSURLSession sessionWithConfiguration:defaultConfiguration
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
  }
  return defaultSession;
}

- (void)handleLockedUserError {
  [APPSSettingsViewControllerDelegate cleanUserDataAndShowStartScreen];
  NSString *message = NSLocalizedString(
      @"Your account was disabled as it wasn't corresponding to our Terms of Service. "
      @"We suggest that you review the Terms of Service carefully along with the "
      @"posts on all accouts you've created.",
      nil);
  UIAlertView *lockedUserAlert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                  otherButtonTitles:nil];
  [lockedUserAlert show];
}

- (void)handleUnsupportedAPIRequestErrorWithResponse:(NSDictionary *)responseObject {
  NSString *responseTypeHeaderKey = @"type";
  NSString *unsupportedAPIVersionType = @"Unstoppable API Version";
  NSString *notAvailableViewControllerID = @"APPSVersionNotAvailableViewController";
  NSRange unsupportedAPIRange =
      [responseObject[responseTypeHeaderKey] rangeOfString:unsupportedAPIVersionType
                                                   options:NSCaseInsensitiveSearch];
  if (unsupportedAPIRange.location == 0 &&
      unsupportedAPIRange.length == unsupportedAPIVersionType.length) {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    newWindow.alpha = 0.0;
    [newWindow setRootViewController:[mainStoryBoard instantiateViewControllerWithIdentifier:
                                                         notAvailableViewControllerID]];
    [[[UIApplication sharedApplication] delegate] setWindow:newWindow];
    [newWindow makeKeyAndVisible];
    CGFloat notAvailableWindowAnimationDuration = 0.5;
    [UIView animateWithDuration:notAvailableWindowAnimationDuration
                     animations:^{ newWindow.alpha = 1.0; }];
  }
}

- (NSURLSessionDataTask *)dataTaskWithSession:(NSURLSession *)session
                                      request:(NSURLRequest *)request
                                   subscriber:(id<RACSubscriber>)subscriber {
  [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
  NSURLSessionDataTask *dataTask = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            id responseObject;
            if (httpResponse) {
              responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              if ([httpResponse statusCode] == HTTPStausCodeOK) {
                [self processResponse:httpResponse];
                if (responseObject) {
                  responseObject = [self mapResponse:responseObject];
                }
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                return;
              }
            }
            NSDictionary *responseDictionary;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
              responseDictionary = (NSDictionary *)responseObject;
            }
            if (!httpResponse) {
              [subscriber sendError:error];
            } else {
              NSString *messageKey = @"message";
              [subscriber
                  sendError:[NSError errorWithDomain:@"APPSRACBaseRequest"
                                                code:0
                                            userInfo:@{
                                              NSLocalizedFailureReasonErrorKey : @"Request failed",
                                              kWebAPIErrorKey : response,
                                              kWebAPIErrorResponseKey :
                                                  responseDictionary[messageKey]
                                                      ? responseDictionary[messageKey]
                                                      : @""
                                            }]];
            }
            if ([httpResponse statusCode] == HTTPStausCodeUnauthorized) {
              [APPSSettingsViewControllerDelegate cleanUserDataAndShowStartScreen];
            } else if ([httpResponse statusCode] == HTTPStausCodeLocked) {
              [self handleLockedUserError];
            } else if ([httpResponse statusCode] == HTTPStausCodeGone) {
              [self handleUnsupportedAPIRequestErrorWithResponse:responseDictionary];
            }
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
  return dataTask;
}

- (void)processResponse:(NSHTTPURLResponse *)response {
}

- (void)cancel {
  if (self.dataTask && ([self.dataTask state] == NSURLSessionTaskStateRunning ||
                        [self.dataTask state] == NSURLSessionTaskStateSuspended)) {
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
  }
  [self.dataTask cancel];
}

- (id)mapResponse:(id)obj {
  return obj;
}

@end
