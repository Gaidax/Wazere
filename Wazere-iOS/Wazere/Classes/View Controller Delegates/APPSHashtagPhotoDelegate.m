//
//  APPSHashtagPhotoDelegate.m
//  Wazere
//
//  Created by iOS Developer on 11/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHashtagPhotoDelegate.h"
#import "APPSRACBaseRequest.h"

@interface APPSHashtagPhotoDelegate ()

@property(strong, NS_NONATOMIC_IOSONLY) NSString *hashtag;

@end

@implementation APPSHashtagPhotoDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user
                               hashtag:(NSString *)hashtag {
  self = [super initWithViewController:viewController user:user];
  if (self) {
    _hashtag = [hashtag stringByReplacingOccurrencesOfString:@"#" withString:@""];
  }
  return self;
}

- (NSMutableDictionary *)addOtherParamsAtParams:(NSMutableDictionary *)params {
  return params;
}

- (APPSRACBaseRequest *)photoRequestWithParams:(NSDictionary *)params {
  // MAKE PHOTO REQUEST
  APPSRACBaseRequest *photoRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              params:params
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:kMediaKeyPath, self.hashtag]
          disposable:nil];
  return photoRequest;
}

@end
