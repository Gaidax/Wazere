//
//  FNViewController.m
//  flocknest
//
//  Created by Ostap on 12/12/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSViewController.h"
#import "APPSViewControllerConfiguratorProtocol.h"
#import "APPSSegueStateProtocol.h"
#import "APPSViewControllerDelegate.h"

@interface APPSViewController ()

@end

@implementation APPSViewController

- (void)dealloc {
  if ([self.configurator respondsToSelector:@selector(cleanUpViewController:)]) {
    [self.configurator cleanUpViewController:self];
  }
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)description {
  NSMutableString *currentUserDescription = [NSMutableString
      stringWithFormat:@"\n[%@ (%p)]:\n{\n", NSStringFromClass([self class]), self];
  return currentUserDescription;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.disposeLeftButton = YES;
  self.view.backgroundColor = kMainBackgroundColor;
  [self.configurator configureViewController:self];

  if (self.disposeLeftButton) {
    self.navigationItem.leftBarButtonItems =
        [[[APPSUtilityFactory sharedInstance] leftBarButtonsUtility]
            leftBarButtonItemsWithTarget:self];
  }
//
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
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(disposeViewControllerNotification:)
                                               name:kMemoryWarningNotificationName
                                             object:nil];
    
    self.screenName = self.delegate ? [self.delegate screenName] : [self screenName];
}

- (NSString *)screenName {
    return @"";
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [self.delegate
          respondsToSelector:@selector(viewController:shouldPerformSegueWithIdentifier:sender:)] ? [self.delegate viewController:self
        shouldPerformSegueWithIdentifier:identifier
                                  sender:sender] : YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [self.state handleSegue:segue sender:sender];
}

- (void)disposeViewController {
  if (self.delegate != (id<APPSViewControllerDelegate>)self &&
      [self.delegate respondsToSelector:@selector(disposeViewController:)]) {
    [self.delegate disposeViewController:self];
  }
  if (self.navigationController && self.navigationController == self.parentViewController &&
      self.navigationController.viewControllers.count > 1) {
    [self.navigationController popViewControllerAnimated:YES];
  } else if (self.parentViewController == self.navigationController &&
             self.navigationController.parentViewController == nil &&
             self.presentingViewController) {
    //presentation context defines parent view controller and not previous view controller
    [self dismissViewControllerAnimated:NO completion:NULL];
  }
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.configurator forKey:@"configurator"];
  [coder encodeObject:self.state forKey:@"state"];
  [coder encodeObject:self.delegate forKey:@"delegate"];
  [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  self.configurator = [coder decodeObjectForKey:@"configurator"];
  self.state = [coder decodeObjectForKey:@"state"];
  self.delegate = [coder decodeObjectForKey:@"delegate"];
  [super decodeRestorableStateWithCoder:coder];
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
}

- (void)disposeViewControllerNotification:(NSNotification *)notification {
  if (self.view.window) {
    [self disposeViewController];
  }
}

@end
