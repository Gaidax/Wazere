//
//  APPSProfileRightButtonStrategy.m
//  Wazere
//
//  Created by Petr Yanenko on 1/21/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSOwnProfileRightButtonStrategy.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSStrategyCollectionViewController.h"

@implementation APPSOwnProfileRightButtonStrategy

@synthesize parentDelegate = _parentDelegate;

- (instancetype)initWithDelegate:(APPSProfileViewControllerDelegate *)delegate {
  self = [super init];
  if (self) {
    _parentDelegate = delegate;
  }
  return self;
}

- (void)rightNavigationButtonAction:(UIBarButtonItem *)sender {
  [self.parentDelegate.parentController
      performSegueWithIdentifier:kSettingsSegue
                          sender:self.parentDelegate.parentController];
}

@end
