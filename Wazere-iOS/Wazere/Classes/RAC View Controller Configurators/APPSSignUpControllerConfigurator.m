//
//  APPSViewControllerConfigurator.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignUpControllerConfigurator.h"
#import "APPSAuthViewController.h"
#import "APPSSignUpViewModel.h"
#import "APPSAuthTableViewCellModel.h"
#import "APPSStrategyControllerDelegate.h"
#import "APPSSignUpTableFooterView.h"
#import "APPSWebViewController.h"

@interface APPSSignUpControllerConfigurator () <
    UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation APPSSignUpControllerConfigurator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Sign up with email";
}

- (void)configureNewUserSession:(APPSCurrentUser *)user {
  [[[APPSUtilityFactory sharedInstance] notificationUtility] updateUserSessionForUser:user];
}

- (void)performSegueOnViewController:(UIViewController *)viewController {
  [[viewController.navigationController.viewControllers firstObject]
      rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
           withSignals:[RACSignal return:mainScreenSegue], [RACSignal return:viewController], nil];
}

- (UIView *)tableHeaderView {
  return [[[NSBundle mainBundle] loadNibNamed:SIGN_UP_TABLE_HEADER_VIEW
                                        owner:nil
                                      options:nil] firstObject];
}

- (UIView *)setupTableHeaderWithController:(APPSRACStrategyTableViewController *)viewController
                                  vieModel:(APPSSignUpViewModel *)viewModel {
  UIView *tableHeaderView = [self tableHeaderView];
  viewController.tableView.tableHeaderView = tableHeaderView;

  @weakify(viewModel);
  [[RACObserve(viewController.tableView, tableHeaderView) ignore:nil]
      subscribeNext:^(UIView *tableViewHeader) {
          @strongify(viewModel);
          ((UIButton *)[tableHeaderView viewWithTag:photoButtonTag]).rac_command =
              viewModel.addPhotoCommand;
      }];
  UIImageView *headerImage = (UIImageView *)[tableHeaderView viewWithTag:photoImageTag];
  [headerImage rac_liftSelector:@selector(setImage:)
                    withSignals:[RACObserve(viewModel, userImage) ignore:nil], nil];

  return tableHeaderView;
}

- (UIView *)setupTableFooterWithController:(APPSRACStrategyTableViewController *)viewController
                                 viewModel:(APPSSignUpViewModel *)viewModel {
  APPSSignUpTableFooterView *tableFooterView = [[APPSSignUpTableFooterView alloc] init];
  CGSize newSize = [tableFooterView sizeThatFits:CGSizeMake(CGRectGetWidth(viewController.tableView.bounds), 0)];
  tableFooterView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
  viewController.tableView.tableFooterView = tableFooterView;
  
  __block NSString *link;
  @weakify(viewController);
  [[RACObserve(tableFooterView, eulaLink) ignore:nil] subscribeNext:^(NSString *eulaLink) {
    @strongify(viewController);
    link = eulaLink;
    [viewController performSegueWithIdentifier:kEulaWebViewSegue sender:viewController];
  }];
  [[viewController rac_signalForSelector:@selector(prepareForSegue:sender:)] subscribeNext:^(RACTuple *params) {
    UIStoryboardSegue *segue = params.first;
    if ([segue.identifier isEqualToString:kEulaWebViewSegue]) {
      APPSWebViewController *destination = [segue destinationViewController];
      destination.url = link;
    }
  }];
  @weakify(viewModel);
  [[RACObserve(viewController.tableView, tableFooterView) ignore:nil]
      subscribeNext:^(UIView *tableFooterView) {
          @strongify(viewModel);
          UIButton *mainButton = (UIButton *)[tableFooterView viewWithTag:mainButtonTag];
          [mainButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
          CGFloat mainButtonFontSize = 14.0;
          mainButton.titleLabel.font = [UIFont systemFontOfSize:mainButtonFontSize];
          [mainButton setImage:[UIImage imageNamed:SIGN_UP_BUTTON_IMAGE_NAME]
                      forState:UIControlStateNormal];
          [mainButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
          mainButton.rac_command = viewModel.signUpCommand;
      }];
  return tableFooterView;
}

- (void)mainLogicWithViewController:(APPSRACStrategyTableViewController *)viewController
                          viewModel:(APPSSignUpViewModel *)viewModel {
  [self setupTableHeaderWithController:viewController vieModel:viewModel];
  [self setupTableFooterWithController:viewController viewModel:viewModel];

  [self handleSignUpCommandWithViewController:viewController viewModel:viewModel];
  [self handlePhotoCommandWithViewController:viewController viewModel:viewModel];
  [self handleActionSheetActionWithViewController:viewController viewModel:viewModel];
  [self handleImagePickerActionWithViewController:viewController viewModel:viewModel];
}

- (void)handleSignUpCommandWithViewController:(APPSRACStrategyTableViewController *)viewController
                                    viewModel:(APPSSignUpViewModel *)viewModel {
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

      [viewController.view endEditing:YES];
      APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:viewController.view];
      [spinner startAnimating];
      @weakify(spinner);
      @weakify(self);
      [signal.dematerialize subscribeNext:^(APPSCurrentUser *user) {
          @strongify(viewController);
          @strongify(spinner);
          @strongify(self);
          [spinner stopAnimating];
          [self configureNewUserSession:user];
          [self performSegueOnViewController:viewController];
          [viewController.navigationController popToRootViewControllerAnimated:NO];
      } error:^(NSError *error) {
          @strongify(spinner);
          [spinner stopAnimating];
          NSHTTPURLResponse *response = [error userInfo][kWebAPIErrorKey];
          NSString *message = NSLocalizedString(
              @"Please enter your email, username and password one more time", nil);
          if ([response statusCode] == HTTPStausCodeBadParams) {
            message = error.userInfo[kWebAPIErrorResponseKey];
          }
          [[[UIAlertView alloc] initWithTitle:nil
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                            otherButtonTitles:nil] show];
      }];
  }];
}

- (void)handlePhotoCommandWithViewController:(APPSRACStrategyTableViewController *)viewController
                                   viewModel:(APPSSignUpViewModel *)viewModel {
  @weakify(self);
  @weakify(viewController);
  [[viewModel.addPhotoCommand executionSignals] subscribeNext:^(RACSignal *signal) {

      [signal subscribeNext:^(UIActionSheet *actionSheet) {
          @strongify(self);
          @strongify(viewController);
          actionSheet.delegate = self;

          [actionSheet showInView:viewController.view];
      }];
  }];
}

- (void)handleActionSheetActionWithViewController:
            (APPSRACStrategyTableViewController *)viewController
                                        viewModel:(APPSSignUpViewModel *)viewModel {
  @weakify(self);
  @weakify(viewController);
  @weakify(viewModel);
  [[[self rac_signalForSelector:@selector(actionSheet:clickedButtonAtIndex:)
                   fromProtocol:@protocol(UIActionSheetDelegate)]
      flattenMap:^RACStream * (RACTuple * tuple) {
          @strongify(viewModel);

          NSNumber *index = tuple.last;

          return [viewModel imagePickerController:index.unsignedIntegerValue];

      }] subscribeNext:^(UIImagePickerController *pickerController) {

      @strongify(self);
      @strongify(viewController);

      pickerController.delegate = self;

      if (pickerController) {
        [viewController rac_liftSelector:@selector(presentViewController:animated:completion:)
                             withSignals:[RACSignal return:pickerController],
                                         [RACSignal return:@YES], [RACSignal return:nil], nil];
      }

  }];
}

- (void)handleImagePickerActionWithViewController:
            (APPSRACStrategyTableViewController *)viewController
                                        viewModel:(APPSSignUpViewModel *)viewModel {
  @weakify(viewModel);
  [[self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)
                  fromProtocol:@protocol(UIImagePickerControllerDelegate)]
      subscribeNext:^(RACTuple *tuple) {
          @strongify(viewModel);

          RACTupleUnpack(UIImagePickerController * pickerController, NSDictionary * info) = tuple;

          NSLog(@"%@, %@", info[UIImagePickerControllerEditedImage],
                info[UIImagePickerControllerOriginalImage]);
          viewModel.userImage = info[UIImagePickerControllerEditedImage];
          [pickerController rac_liftSelector:@selector(dismissViewControllerAnimated:completion:)
                                 withSignals:[RACSignal return:@YES], [RACSignal return:nil], nil];
      }];
}

@end
