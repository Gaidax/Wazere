//
//  APPSHashtagPhotosDelegate.m
//  Wazere
//
//  Created by Gaidax on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHashtagPhotosDelegate.h"
#import "APPSRACBaseRequest.h"
#import "APPSHashtagModel.h"
#import "APPSShowProfilePhotoRectLayout.h"
#import "APPSShowProfilePhotoLayout.h"

@interface APPSHashtagPhotosDelegate ()
@end

@implementation APPSHashtagPhotosDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user {
  self = [super initWithViewController:viewController user:user];
  if (self) {
    self.selectedTab = APPSProfileSelectedTabTypeList;
  }
  return self;
}

- (NSMutableDictionary *)addOtherParamsAtParams:(NSMutableDictionary *)params {
  return params;
}

- (APPSRACBaseRequest *)photoRequestWithParams:(NSDictionary *)params {
  APPSRACBaseRequest *photoRequest = [[APPSRACBaseRequest alloc]
      initWithObject:nil
              params:params
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:kHashtagPhotosKeyPath, self.hashtag.name]

          disposable:nil];
  return photoRequest;
}

- (void)loadData {
  [super loadPhotos];
}

- (void)initCollectionViewLayouts {
  self.rectCollectionViewLayout = [[APPSShowProfilePhotoRectLayout alloc] init];
  self.rectCollectionViewLayout.delegate = self;
  self.squareCollectionViewLayout = nil;
  self.baseLayout = [[APPSShowProfilePhotoLayout alloc] init];
}

- (BOOL)shouldHighlightTabbarCameraButton {
  return NO;
}

- (NSString *)screenName {
    return @"Hashatag photos";
}

@end
