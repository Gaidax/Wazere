//
//  APPSOtherProfileRightButtonStrategy.m
//  Wazere
//
//  Created by Petr Yanenko on 1/21/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSOtherProfileRightButtonStrategy.h"
#import "APPSRACBaseRequest.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSUserProtocol.h"
#import "APPSStrategyCollectionViewController.h"
#import "APPSSomeUser.h"

@interface APPSOtherProfileRightButtonStrategy () <UIActionSheetDelegate, UIAlertViewDelegate>
@property(weak, nonatomic) UIActionSheet *blockSheet;

@end

@implementation APPSOtherProfileRightButtonStrategy

- (void)dealloc {
  _blockSheet.delegate = nil;
}

- (void)rightNavigationButtonAction:(UIBarButtonItem *)sender {
  APPSSomeUser *someUser = (APPSSomeUser *)self.parentDelegate.user;
  NSString *blockTitle = [someUser.isBlocked boolValue] ? NSLocalizedString(@"Unblock user", nil) :
                                                          NSLocalizedString(@"Block user", nil);
  UIActionSheet *blockSheet =
      [[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                    destructiveButtonTitle:NSLocalizedString(@"Mark as Inappropriate", nil)
                         otherButtonTitles:blockTitle, nil];
  UITabBar *tabBar = self.parentDelegate.parentController.tabBarController.tabBar;
  if (tabBar) {
    [blockSheet showFromTabBar:tabBar];
  } else {
    [blockSheet showInView:self.parentDelegate.parentController.view];
  }
  self.blockSheet = blockSheet;
}

- (void)showBlockUserConfirmnation {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Yes, I'm sure", nil), nil];
    
    [alertView show];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == actionSheet.destructiveButtonIndex) {
    self.parentDelegate.parentController.navigationItem.rightBarButtonItem.enabled = NO;
    APPSRACBaseRequest *request = [[APPSRACBaseRequest alloc]
        initWithObject:nil
                method:HTTPMethodPOST
               keyPath:[NSString stringWithFormat:kKeyPathForUserComplaint,
                                                  self.parentDelegate.user.userId]
            disposable:nil];
    @weakify(self);
    [[request execute] subscribeNext:^(id _) {
        @strongify(self);
        [self.parentDelegate.parentController reloadCollectionView];
        NSString *message = NSLocalizedString(
            @"Your concerns are very important to us. We will investigate this issue. "
            @"Action will be taken if we deem there to be a violation of our Community Guidelines",
            nil);
        NSString *title = NSLocalizedString(@"THANK YOU", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    } completed:^{
        @strongify(self);
        self.parentDelegate.parentController.navigationItem.rightBarButtonItem.enabled = YES;
    }];
  } else if (buttonIndex != actionSheet.cancelButtonIndex) {
      [self showBlockUserConfirmnation];
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    APPSSomeUser *someUser = (APPSSomeUser *)self.parentDelegate.user;
    NSString *requestMethod = [someUser.isBlocked boolValue] ? HTTPMethodDELETE : HTTPMethodPOST;
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.parentDelegate.parentController.navigationItem.rightBarButtonItem.enabled = NO;
        APPSRACBaseRequest *request = [[APPSRACBaseRequest alloc]
                                       initWithObject:nil
                                       method:requestMethod
                                       keyPath:[NSString stringWithFormat:kKeyPathForUserBlocking,
                                                someUser.userId]
                                       disposable:nil];
        @weakify(self);
        [[request execute] subscribeNext:^(id _) {
            @strongify(self);
            someUser.isBlocked = @(![someUser.isBlocked boolValue]);
            if ([someUser.isBlocked boolValue] && [[(APPSSomeUser *)self.parentDelegate.user isFollowed] boolValue]) {
              [[[APPSUtilityFactory sharedInstance] followUtility]
                updateFollowStatusAndPostNotificationForUser:(APPSSomeUser *)self.parentDelegate.user];
            }
            [self.parentDelegate.parentController reloadCollectionView];
            NSString *title = [someUser.isBlocked boolValue] ? NSLocalizedString(@"User blocked", nil) :
                                                   NSLocalizedString(@"User unblocked", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:nil
                                                            delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        } completed:^{
            @strongify(self);
            self.parentDelegate.parentController.navigationItem.rightBarButtonItem.enabled = YES;
        }];

    }
}

@end
