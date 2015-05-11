//
//  APPSResetPasswordConfigurator.m
//  Wazere
//
//  Created by Petr Yanenko on 9/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSResetPasswordConfigurator.h"
#import "APPSRACStrategyTableViewController.h"
#import "APPSSignUpViewModel.h"
#import "APPSAuthTableViewCellModel.h"

@implementation APPSResetPasswordConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Password reset confirmation";
}

- (UIView *)setupTableHeaderWithController:(APPSRACStrategyTableViewController *)viewController
                                  vieModel:(APPSSignUpViewModel *)viewModel {
  UIView *tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:SIGN_IN_TABLE_HEADER_VIEW
                                                           owner:nil
                                                         options:nil] firstObject];
  viewController.tableView.tableHeaderView = tableHeaderView;

  [(UIButton *)[tableHeaderView viewWithTag:forgetPasswordButtonTag] setHidden:YES];

  return tableHeaderView;
}

- (UIView *)setupTableFooterWithController:(APPSRACStrategyTableViewController *)viewController
                                 viewModel:(APPSSignUpViewModel *)viewModel {
  UIView *tableFooterView = [[[NSBundle mainBundle] loadNibNamed:AUTH_TABLE_FOOTER_VIEW
                                                           owner:nil
                                                         options:nil] firstObject];

  viewController.tableView.tableFooterView = tableFooterView;

  @weakify(viewModel);
  [[RACObserve(viewController.tableView, tableFooterView) ignore:nil]
      subscribeNext:^(UIView *tableFooterView) {
          @strongify(viewModel);
          UIButton *loginButton = (UIButton *)[tableFooterView viewWithTag:mainButtonTag];
          [loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
          CGFloat loginButtonFontSize = 14.0;
          loginButton.titleLabel.font = [UIFont systemFontOfSize:loginButtonFontSize];
          loginButton.rac_command = viewModel.signUpCommand;
      }];
  return tableFooterView;
}

- (void)mainLogicWithViewController:(APPSRACStrategyTableViewController *)viewController
                          viewModel:(APPSSignUpViewModel *)viewModel {
  [self setupTableHeaderWithController:viewController vieModel:viewModel];
  [self setupTableFooterWithController:viewController viewModel:viewModel];

  @weakify(viewController);
  [viewModel.signUpCommand.executionSignals subscribeNext:^(RACSignal *signal) {
      @strongify(viewController);
      [[NSNotificationCenter defaultCenter] postNotificationName:kShakeTextFieldNotificationName
                                                          object:self];
      for (APPSAuthTableViewCellModel *cellModel in viewModel.objects) {
          if (!cellModel.isFieldValid) {
              return;
          }
      }
      
      APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:viewController.view];
      [spinner startAnimating];
      [viewController.view endEditing:YES];
      @weakify(spinner);
      [signal.dematerialize subscribeNext:^(APPSCurrentUser *user) {
          [[[APPSUtilityFactory sharedInstance] notificationUtility] updateUserSessionForUser:user];
          [viewController.navigationController.viewControllers[0]
              rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
                   withSignals:[RACSignal return:mainScreenSegue],
                               [RACSignal return:viewController], nil];
          [viewController.navigationController popToRootViewControllerAnimated:NO];
          @strongify(spinner);
          [spinner stopAnimating];
      } error:^(NSError *error) {
          NSHTTPURLResponse *response = [error userInfo][kWebAPIErrorKey];
          NSString *message =
              NSLocalizedString(@"Please enter your username and passwords one more time", nil);
          if ([response statusCode] == HTTPStausCodeNotFound) {
            message =
                NSLocalizedString(@"Your username/password is incorrect. Please try again.", nil);
          }
          [[[UIAlertView alloc] initWithTitle:nil
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                            otherButtonTitles:nil] show];
          @strongify(spinner);
          [spinner stopAnimating];
      }];
  }];
}

@end
