//
//  APPSSignUpFacebookSearchDelegate.m
//  Wazere
//
//  Created by iOS Developer on 12/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSignUpFacebookSearchDelegate.h"
#import "APPSStrategyTableViewController.h"

@interface APPSSignUpFacebookSearchDelegate ()

@property(assign, NS_NONATOMIC_IOSONLY) BOOL didShow;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL goHome;

@end

@implementation APPSSignUpFacebookSearchDelegate

- (void)dealloc {
  super.parentController.navigationController.delegate = nil;
}

- (void)goToHomeScreen {
  [[[APPSCurrentUserManager sharedInstance] currentUser] setShowFacebookFriends:NO];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
  UITabBarController *tabBar =
      [storyboard instantiateViewControllerWithIdentifier:kTabBarControllerStoryboardID];
  UINavigationController *presentingViewController =
      (UINavigationController *)self.parentController.presentingViewController;
  [presentingViewController dismissViewControllerAnimated:NO completion:^{
    [presentingViewController presentViewController:tabBar animated:NO completion:NULL];
  }];
}

- (void)nextButtonAction:(UIButton *)sender {
  [self goToHomeScreen];
}

- (void)setCurrentResultState:(APPSLoadingResultState)currentResultState {
  [super setCurrentResultState:currentResultState];
  if (currentResultState == APPSLoadingResultStateNoResults) {
    self.goHome = YES;
    if (self.didShow) {
        [self goToHomeScreen];      
    }
  }
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  self.didShow = YES;
  if (self.goHome) {
    [self goToHomeScreen];
  }
}

@end
