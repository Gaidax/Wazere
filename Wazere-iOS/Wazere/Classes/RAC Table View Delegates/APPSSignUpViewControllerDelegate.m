//
//  APPSSignUpViewControllerDelegate.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignUpViewControllerDelegate.h"

#import "APPSAuthTableViewCell.h"
#import "NSString+Validation.h"

@interface APPSSignUpViewControllerDelegate () <
    UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(weak, nonatomic) APPSAuthViewController *viewController;

@end

@implementation APPSSignUpViewControllerDelegate

@synthesize viewModel = _viewModel;

- (instancetype)initWithController:(APPSAuthViewController *)viewController {
  self = [super init];

  if (self) {
    _viewController = viewController;
    [self handleTextFieldDidBeginEditing:viewController];
    [self handleTextFiledDidEndEditingWithViewController:viewController];
    [self handleTextFieldShouldReturnActionWithViewController:viewController];
  }

  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self initWithController:nil];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.viewModel.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  APPSAuthTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"APPSAuthTableViewCell"];

  cell.textField.delegate = self;
  cell.textField.tag = indexPath.row;
  cell.model = self.viewModel.objects[indexPath.row];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 51.f;
}

- (void)reloadTableViewController:(APPSRACStrategyTableViewController *__weak)parentController {
}

#pragma mark - Text field delegate

- (void)handleTextFieldDidBeginEditing:(APPSRACStrategyTableViewController *)viewController {
  @weakify(viewController);

  [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:)
                  fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {
      @strongify(viewController);

      UITextField *textField = tuple.first;
      viewController.firstResponder = textField;
  }];
}

- (void)handleTextFiledDidEndEditingWithViewController:
            (APPSRACStrategyTableViewController *)viewController {
  @weakify(viewController);
  [[self rac_signalForSelector:@selector(textFieldDidEndEditing:)
                  fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {

      @strongify(viewController);

      UITextField *textField = tuple.first;
      viewController.firstResponder = nil;
      [textField resignFirstResponder];

      CGPoint buttonPosition = [textField convertPoint:CGPointZero toView:viewController.tableView];
      NSIndexPath *indexPath = [viewController.tableView indexPathForRowAtPoint:buttonPosition];
      APPSAuthTableViewCell *cell =
          (APPSAuthTableViewCell *)[viewController.tableView cellForRowAtIndexPath:indexPath];
      if (!cell) {
        return;
      }

      APPSAuthTableViewCellModel *cellModel = self.viewModel.objects[indexPath.row];
      if (!cellModel.isFieldValid) {
        [cell shakeWrongDataTextField];
      }
  }];
}

- (void)handleTextFieldShouldReturnActionWithViewController:
            (APPSRACStrategyTableViewController *)viewController {
  @weakify(viewController);
  [[self rac_signalForSelector:@selector(textFieldShouldReturn:)
                  fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {
      @strongify(viewController);

      UITextField *textField = tuple.first;
      [textField resignFirstResponder];

      CGPoint buttonPosition = [textField convertPoint:CGPointZero toView:viewController.tableView];
      NSIndexPath *indexPath = [viewController.tableView indexPathForRowAtPoint:buttonPosition];

      APPSAuthTableViewCell *nextCell = (APPSAuthTableViewCell *)[viewController.tableView
          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1
                                                   inSection:indexPath.section]];
      APPSAuthTableViewCell *cell =
          (APPSAuthTableViewCell *)[viewController.tableView cellForRowAtIndexPath:indexPath];

      if (nextCell) {
        [nextCell.textField becomeFirstResponder];
      } else {
        [cell.textField resignFirstResponder];
      }
  }];
}

@end
