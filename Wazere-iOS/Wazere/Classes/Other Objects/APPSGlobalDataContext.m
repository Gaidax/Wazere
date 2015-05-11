//
//  GlobalDataContext.m
//  flocknest
//
//  Created by iOS Developer on 12/27/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSGlobalDataContext.h"

@interface APPSGlobalDataContext ()

@end

@implementation APPSGlobalDataContext

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

+ (APPSGlobalDataContext *)getInstance {
  static APPSGlobalDataContext *context = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ context = [APPSGlobalDataContext new]; });
  return context;
}

- (void)initializeWithLaunchOptions:(NSDictionary *)launchOptions {
}

@end
