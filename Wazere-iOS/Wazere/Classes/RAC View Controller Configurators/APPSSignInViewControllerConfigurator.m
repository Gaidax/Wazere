//
//  APPSSignInViewControllerConfigurator.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignInViewControllerConfigurator.h"
#import "APPSAuthViewController.h"
#import "APPSSignInViewModel.h"

#import "APPSForgotPasswordConfigurator.h"
#import "APPSForgotPasswordViewModel.h"
#import "APPSSignUpViewControllerDelegate.h"
#import "APPSAuthTableViewCellModel.h"

@implementation APPSSignInViewControllerConfigurator

static NSInteger const mainFooterButtonTag = 1;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Sign in";
}

- (UIView *)setupTableHeaderWithController:(APPSRACStrategyTableViewController *)viewController
                                  vieModel:(APPSSignInViewModel *)viewModel {
  UIView *tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:SIGN_IN_TABLE_HEADER_VIEW
                                                           owner:nil
                                                         options:nil] firstObject];
  viewController.tableView.tableHeaderView = tableHeaderView;

  @weakify(viewModel);
  [[RACObserve(viewController.tableView, tableHeaderView) ignore:nil]
      subscribeNext:^(UIView *tableHeaderView) {
          @strongify(viewModel);
          [(UIButton *)[tableHeaderView viewWithTag:forgetPasswordButtonTag]
              setTitle:NSLocalizedString(@"Forgot your password?", nil)
              forState:UIControlStateNormal];
          ((UIButton *)[tableHeaderView viewWithTag:forgetPasswordButtonTag]).titleLabel.font =
              FONT_CHAMPAGNE_LIMOUSINES(12.5);
          ((UIButton *)[tableHeaderView viewWithTag:forgetPasswordButtonTag]).rac_command =
              viewModel.forgotPasswordCommand;
      }];

  return tableHeaderView;
}

- (UIView *)setupTableFooterWithController:(APPSRACStrategyTableViewController *)viewController
                                 viewModel:(APPSSignInViewModel *)viewModel {
  UIView *tableFooterView = [[[NSBundle mainBundle] loadNibNamed:AUTH_TABLE_FOOTER_VIEW
                                                           owner:nil
                                                         options:nil] firstObject];

  viewController.tableView.tableFooterView = tableFooterView;

  @weakify(viewModel);
  [[RACObserve(viewController.tableView, tableFooterView) ignore:nil]
      subscribeNext:^(UIView *tableFooterView) {
          @strongify(viewModel);
          UIButton *loginButton = (UIButton *)[tableFooterView viewWithTag:mainFooterButtonTag];
          [loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
          CGFloat loginButtonFontSize = 14.0;
          loginButton.titleLabel.font = [UIFont systemFontOfSize:loginButtonFontSize];
          loginButton.rac_command = viewModel.signInCommand;
      }];
  return tableFooterView;
}

- (void)mainLogicWithViewController:(APPSRACStrategyTableViewController *)viewController
                          viewModel:(APPSSignInViewModel *)viewModel {
  [self setupTableHeaderWithController:viewController vieModel:viewModel];
  [self setupTableFooterWithController:viewController viewModel:viewModel];

  [self handleSignInCommandWithViewController:viewController viewModel:viewModel];
  [self handleForgotPasswordCommandWithViewController:viewController viewModel:viewModel];
}

- (void)handleSignInCommandWithViewController:(APPSRACStrategyTableViewController *)viewController
                                    viewModel:(APPSSignInViewModel *)viewModel {
  @weakify(viewController);
  [viewModel.signInCommand.executionSignals subscribeNext:^(RACSignal *signal) {
      @strongify(viewController);
      [[NSNotificationCenter defaultCenter] postNotificationName:kShakeTextFieldNotificationName
                                                          object:self];
      for (APPSAuthTableViewCellModel *cellModel in viewModel.objects) {
          if (!cellModel.isFieldValid) {
              return;
          }
      }
      
      [viewController.view endEditing:YES];
      APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:viewController.view];
      [spinner startAnimating];
      @weakify(spinner);
      [signal.dematerialize subscribeNext:^(APPSCurrentUser *user) {
          @strongify(spinner);
          [spinner stopAnimating];
          [[[APPSUtilityFactory sharedInstance] notificationUtility] updateUserSessionForUser:user];
          [viewController.navigationController.viewControllers[0]
              rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
                   withSignals:[RACSignal return:mainScreenSegue],
                               [RACSignal return:viewController], nil];
          [viewController.navigationController popToRootViewControllerAnimated:NO];
      } error:^(NSError *error) {
          @strongify(spinner);
          [spinner stopAnimating];
          NSHTTPURLResponse *response = [error userInfo][kWebAPIErrorKey];
          NSString *message = NSLocalizedString(
              @"Please enter your username/email and password one more time", nil);
          if ([response statusCode] == HTTPStausCodeNotFound) {
            message =
                NSLocalizedString(@"Your email/password is incorrect. Please try again.", nil);
          }
          [[[UIAlertView alloc] initWithTitle:nil
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                            otherButtonTitles:nil] show];
      }];
  }];
}

- (void)handleForgotPasswordCommandWithViewController:
            (APPSRACStrategyTableViewController *)viewController
                                            viewModel:(APPSSignInViewModel *)viewModel {
  @weakify(viewController);
  [[viewModel.forgotPasswordCommand executionSignals] subscribeNext:^(RACSignal *signal) {
      @strongify(viewController);
      APPSAuthViewController *mainAuthSceneController =
          [[UIStoryboard storyboardWithName:kStoryboardName bundle:NULL]
              instantiateViewControllerWithIdentifier:@"APPSSignUpViewController"];
      APPSForgotPasswordViewModel *viewModel = [[APPSForgotPasswordViewModel alloc] init];
      APPSSignUpViewControllerDelegate *delegate =
          [[APPSSignUpViewControllerDelegate alloc] initWithController:mainAuthSceneController];
      delegate.viewModel = viewModel;
      APPSForgotPasswordConfigurator *conf = [[APPSForgotPasswordConfigurator alloc] init];
      mainAuthSceneController.delegate = delegate;
      mainAuthSceneController.mainLogicDelegate = conf;

      [viewController.navigationController pushViewController:mainAuthSceneController animated:YES];
  }];
}

@end
