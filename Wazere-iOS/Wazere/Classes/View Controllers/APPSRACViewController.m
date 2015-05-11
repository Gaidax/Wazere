//
//  FNViewController.m
//  flocknest
//
//  Created by Ostap on 12/12/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSRACViewController.h"

@interface APPSRACViewController ()

@end

@implementation APPSRACViewController

- (NSString *)description {
  NSMutableString *currentUserDescription = [NSMutableString
      stringWithFormat:@"\n[%@ (%p)]:\n{\n", NSStringFromClass([self class]), self];
  return currentUserDescription;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.keyboardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(triggersKeyboardRecognizer:)];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShows:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHides:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];

  self.navigationController.navigationBar.topItem.title = @"";
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)disposeViewController {
  if (self.navigationController && self.navigationController.viewControllers.count > 1) {
    [self.navigationController popViewControllerAnimated:YES];
  } else if (self.presentingViewController) {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
  }
}

- (void)updateConstraintsForShownKeyboardBounds:(CGRect)keyboardBounds
                                 animationCurve:(UIViewAnimationCurve)curve {
}

- (void)updateConstraintsForHiddenKeyboardWithBounds:(CGRect)bounds
                                      animationCurve:(UIViewAnimationCurve)curve {
}

- (void)keyboardWillShows:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  NSValue *kbFrame = info[UIKeyboardFrameEndUserInfoKey];
  NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  CGRect keyboardFrame = [kbFrame CGRectValue];

  [self updateConstraintsForShownKeyboardBounds:keyboardFrame animationCurve:animationCurve];
  [self.view updateConstraintsIfNeeded];
  [UIView animateWithDuration:animationDuration animations:^{ [self.view layoutIfNeeded]; }];

  [self.view addGestureRecognizer:self.keyboardTapRecognizer];
}

- (void)keyboardWillHides:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];

  CGRect keyboardBounds;
  [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];

  [self updateConstraintsForHiddenKeyboardWithBounds:keyboardBounds animationCurve:animationCurve];
  [self.view updateConstraintsIfNeeded];
  [UIView animateWithDuration:animationDuration animations:^{ [self.view layoutIfNeeded]; }];
  [self.view removeGestureRecognizer:self.keyboardTapRecognizer];
}

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  if (self.view.window) {
    [self disposeViewController];
  }
}
@end
