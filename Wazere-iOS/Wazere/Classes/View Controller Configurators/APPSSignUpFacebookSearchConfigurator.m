//
//  APPSSignUpFacebookSearchConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 12/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignUpFacebookSearchConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSignUpFacebookSearchDelegate.h"

@implementation APPSSignUpFacebookSearchConfigurator

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  [super configureViewController:controller];
  controller.navigationController.delegate = (APPSSignUpFacebookSearchDelegate *)controller.delegate;
  UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat buttonWidth = 50, buttonHeight = 44;
  nextButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
  [nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
  [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  CGFloat nextButonFontSize = 14;
  nextButton.titleLabel.font = [UIFont systemFontOfSize:nextButonFontSize];
  [nextButton addTarget:controller.delegate action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
  controller.navigationItem.rightBarButtonItem = rightItem;
  controller.disposeLeftButton = NO;
}

@end
