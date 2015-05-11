//
//  APPSNavigationViewController.m
//  Wazere
//
//  Created by iOS Developer on 9/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNavigationViewController.h"

@implementation APPSNavigationViewController

- (void)dealloc {
  self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[UINavigationBar appearance] setTitleTextAttributes:@{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : FONT_CHAMPAGNE_LIMOUSINES_BOLD(20.f)
  }];

  UIColor *backgroundColor = kMainBackgroundColor;
  self.view.backgroundColor = backgroundColor;
  self.navigationBar.barTintColor = backgroundColor;
  self.navigationBar.tintColor = [UIColor whiteColor];
  [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationBar.shadowImage = [UIImage new];
  self.navigationBar.translucent = NO;

  __weak APPSNavigationViewController *weakSelf = self;
  if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.interactivePopGestureRecognizer.delegate = weakSelf;
  }
}

@end
