//
//  APPSTwitterAuthViewController.m
//  Wazere
//
//  Created by Gaidax on 11/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSTwitterAuthViewController.h"

@interface APPSTwitterAuthViewController ()

@end

@implementation APPSTwitterAuthViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.screenName = @"Twitter account authorization";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{
                               [[[APPSUtilityFactory sharedInstance] twitterUtility]
                                   photoSharedSuccessfully:NO
                                                completion:NULL];
                           }];
}

@end
