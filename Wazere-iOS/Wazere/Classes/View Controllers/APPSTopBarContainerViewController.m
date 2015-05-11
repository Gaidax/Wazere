//
//  APPSTopBarContainerViewController.m
//  Wazere
//
//  Created by Petr Yanenko on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSTopBarContainerViewController.h"

@interface APPSTopBarContainerViewController ()

@end

@implementation APPSTopBarContainerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)tapsLeftButton:(UIButton *)sender {
  [self.delegate topBarContainerViewController:self tapsLeftButton:sender];
}

- (IBAction)tapsRightButton:(UIButton *)sender {
  [self.delegate topBarContainerViewController:self tapsRightButton:sender];
}

- (IBAction)tapsCenterButton:(UIButton *)sender {
  [self.delegate topBarContainerViewController:self tapsCenterButton:sender];
}

@end
