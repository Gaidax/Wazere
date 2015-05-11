//
//  APPSHashtagPhotoConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 11/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHashtagPhotoConfigurator.h"

@interface APPSHashtagPhotoConfigurator ()

@property(strong, NS_NONATOMIC_IOSONLY) NSString *hashtag;

@end

@implementation APPSHashtagPhotoConfigurator

- (instancetype)initWithHashtag:(NSString *)hashtag {
  self = [super init];
  if (self) {
    _hashtag = hashtag;
  }
  return self;
}

- (void)configureViewController:(UIViewController *)controller {
  [super configureViewController:controller];
  controller.title = self.hashtag;
}

@end
