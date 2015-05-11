//
//  APPSForgotPasswordConfigurator.m
//  Wazere
//
//  Created by Petr Yanenko on 9/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSForgotPasswordConfigurator.h"

#import "APPSSignUpViewModel.h"
#import "APPSResetPasswordViewModel.h"

#import "APPSRACStrategyTableViewController.h"
#import "APPSAuthViewController.h"

#import "APPSSignUpViewControllerDelegate.h"
#import "APPSResetPasswordConfigurator.h"

#import "APPSResetPasswordAlertView.h"
#import "APPSAuthTableViewCellModel.h"

@interface APPSForgotPasswordConfigurator () <APPSResetPasswordAlertViewDelegate>

@property(strong, NS_NONATOMIC_IOSONLY) APPSResetPasswordAlertView *alertView;

@end

@implementation APPSForgotPasswordConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (NSString *)screenName {
  return @"Forgot password";
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
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
          UIButton *resetButton = (UIButton *)[tableFooterView viewWithTag:mainButtonTag];
          [resetButton setTitle:NSLocalizedString(@"Send a new password to Email", nil)
                       forState:UIControlStateNormal];
          CGFloat resetButtonFontSize = 14.0;
          resetButton.titleLabel.font = [UIFont systemFontOfSize:resetButtonFontSize];
          resetButton.rac_command = viewModel.signUpCommand;
      }];
  return tableFooterView;
}

- (void)mainLogicWithViewController:(APPSRACStrategyTableViewController *)viewController
                          viewModel:(APPSSignUpViewModel *)viewModel {
  [self setupTableHeaderWithController:viewController vieModel:viewModel];
  [self setupTableFooterWithController:viewController viewModel:viewModel];
  [self handleSignUpCommandWithViewController:viewController viewModel:viewModel];
  [self handleOkButtonTouchWithViewController:viewController];
}

- (void)handleSignUpCommandWithViewController:(APPSRACStrategyTableViewController *)viewController
                                    viewModel:(APPSSignUpViewModel *)viewModel {
  @weakify(self);
  @weakify(viewController);
  [[viewModel.signUpCommand executionSignals] subscribeNext:^(RACSignal *commandSignal) {
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
      [commandSignal.dematerialize subscribeNext:^(id _) {
          @strongify(self);
          @strongify(spinner);
          self.alertView = [[APPSResetPasswordAlertView alloc] init];
          self.alertView.delegate = self;
          self.alertView.autoresizingMask =
              UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
          self.alertView.frame = viewController.view.bounds;
          [viewController.view addSubview:self.alertView];
          [spinner stopAnimating];
      } error:^(NSError *error) {
          @strongify(spinner);
          NSHTTPURLResponse *response = [error userInfo][kWebAPIErrorKey];
          NSString *message =
              NSLocalizedString(@"Please enter your username and password one more time", nil);
          if ([response statusCode] == HTTPStausCodeNotFound) {
            message =
                NSLocalizedString(@"We couldn’t find your email address. Please enter your "
                                  @"username or valid email address",
                                  nil);
          }
          [[[UIAlertView alloc] initWithTitle:nil
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                            otherButtonTitles:nil] show];
          [spinner stopAnimating];
      }];
  }];
}

- (void)handleOkButtonTouchWithViewController:(APPSRACStrategyTableViewController *)viewController {
  @weakify(viewController);
  [[self rac_signalForSelector:@selector(okButtonDidTouch)
                  fromProtocol:@protocol(APPSResetPasswordAlertViewDelegate)]
      subscribeNext:^(RACTuple *parameters) {
          @strongify(viewController);
          [self.alertView removeFromSuperview];
          APPSAuthViewController *mainAuthSceneController =
              [[UIStoryboard storyboardWithName:kStoryboardName bundle:NULL]
                  instantiateViewControllerWithIdentifier:@"APPSSignUpViewController"];
          APPSResetPasswordViewModel *viewModel = [[APPSResetPasswordViewModel alloc] init];
          APPSSignUpViewControllerDelegate *delegate =
              [[APPSSignUpViewControllerDelegate alloc] initWithController:mainAuthSceneController];
          delegate.viewModel = viewModel;
          APPSResetPasswordConfigurator *conf = [[APPSResetPasswordConfigurator alloc] init];
          mainAuthSceneController.delegate = delegate;
          mainAuthSceneController.mainLogicDelegate = conf;

          [viewController.navigationController pushViewController:mainAuthSceneController
                                                         animated:YES];
      }];
}

@end
