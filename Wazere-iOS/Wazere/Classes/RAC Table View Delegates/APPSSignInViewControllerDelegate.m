//
//  APPSSignInViewControllerDelegate.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignInViewControllerDelegate.h"

#import "APPSAuthTableViewCell.h"

@interface APPSSignInViewControllerDelegate () <UITextFieldDelegate>

@property(weak, nonatomic) APPSAuthViewController *viewController;

@end

@implementation APPSSignInViewControllerDelegate
@synthesize viewModel = _viewModel;

- (instancetype)initWithController:(APPSAuthViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;

    @weakify(viewController);

    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:)
                    fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(viewController);
        UITextField *textField = tuple.first;
        viewController.firstResponder = textField;
    }];

    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:)
                    fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(viewController);
        UITextField *textField = tuple.first;
        viewController.firstResponder = nil;
        [textField resignFirstResponder];

        CGPoint buttonPosition =
            [textField convertPoint:CGPointZero toView:viewController.tableView];
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
    [self initializeTextFieldShouldReturnSignalWithViewController:viewController];
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

- (void)initializeTextFieldShouldReturnSignalWithViewController:
            (APPSAuthViewController *)viewController {
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
      if (nextCell) {
        [nextCell.textField becomeFirstResponder];
      } else {
        APPSAuthTableViewCell *cell =
            (APPSAuthTableViewCell *)[viewController.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField resignFirstResponder];
      }
  }];
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
  cell.model = self.viewModel.objects[indexPath.row];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 51.f;
}

- (void)reloadTableViewController:(APPSRACStrategyTableViewController *__weak)parentController {
}

@end
