//
//  APPSVersionNotAvailableViewController.m
//  Wazere
//
//  Created by Petr Yanenko on 1/31/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSVersionNotAvailableViewController.h"

@interface APPSVersionNotAvailableViewController ()

@end

@implementation APPSVersionNotAvailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openURL:(UIButton *)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kITunesLink]];
}

@end
