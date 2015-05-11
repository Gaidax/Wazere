//
//  APPSStartScreenViewModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSStartScreenViewModel.h"
#import "APPSAuthCommand.h"

@interface APPSStartScreenViewModel ()

@property(nonatomic, strong) APPSRACBaseRequest *authCommand;

@end

@implementation APPSStartScreenViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.facebookSignInCommand = [self createFacebookSignInCommand];
  }
  return self;
}

- (RACCommand *)createFacebookSignInCommand {
  @weakify(self);
  return [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
      @strongify(self);
      return [self openFacebookSessionSignal];
  }];
}

- (RACSignal *)openFacebookSessionSignal {
  @weakify(self);
  return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
      [[[APPSUtilityFactory sharedInstance] facebookUtility]
          openSessionWithHandler:^(NSString *token, NSError *error) {
              @strongify(self);
              if (token) {
                NSDictionary *params = @{facebookTokenParamKey : token};
                self.authCommand = [[APPSAuthCommand alloc] initWithObject:nil
                                                                    params:params
                                                                    method:facebookSignUpMethod
                                                                   keyPath:KeyPathFacebookSignIn
                                                                disposable:nil];
                [self.authCommand.execute subscribeNext:^(APPSCurrentUser *user) {
                  if (user) {
                    [subscriber sendNext:user];
                    [subscriber sendCompleted];
                  } else {
                    [[[APPSUtilityFactory sharedInstance] facebookUtility] closeSession];
                    [subscriber sendError:[NSError errorWithDomain:@"APPSStartScreenModel"
                                                             code:1
                                                         userInfo:@{
                                                                    NSLocalizedFailureReasonErrorKey :
                                                                      @"User is nil"
                                                                    }]];
                  }
                } error:^(NSError *error) {
                  [[[APPSUtilityFactory sharedInstance] facebookUtility] closeSession];
                  [subscriber sendError:error];
                }];
              } else if (error) {
                [subscriber sendError:error];
              } else {
                [subscriber sendError:[NSError errorWithDomain:@"APPSStartScreenModel"
                                                          code:0
                                                      userInfo:@{
                                                        NSLocalizedFailureReasonErrorKey :
                                                            @"User canceled request"
                                                      }]];
              }
          }];
      return nil;
  }];
}

@end
