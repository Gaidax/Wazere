//
//  APPSLikedPhotosDelegate.m
//  Wazere
//
//  Created by iOS Developer on 10/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSLikedPhotosDelegate.h"
#import "APPSRACBaseRequest.h"

@implementation APPSLikedPhotosDelegate

- (NSString *)screenName {
    return @"Who liked your photo list";
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
             keyPath:[NSString
                         stringWithFormat:kLikedPhotosKeyPath,
                                          (unsigned long)[self.user.userId unsignedIntegerValue]]
          disposable:nil];
  return photoRequest;
}

@end
