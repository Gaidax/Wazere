//
//  APPSAuthViewController.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAuthViewController.h"
#import "APPSFunctionalLogicDelegate.h"

@interface APPSAuthViewController ()
@end

@implementation APPSAuthViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = kMainBackgroundColor;
  self.screenName = [self.mainLogicDelegate screenName];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
