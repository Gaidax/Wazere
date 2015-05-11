//
//  APPSFacebookSignUpControllerConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 9/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFacebookSignUpControllerConfigurator.h"
#import "APPSAuthViewController.h"
#import "APPSFacebookSignUpViewModel.h"
#import "APPSFacebookSignUpTableHeaderView.h"

@interface APPSFacebookSignUpControllerConfigurator ()

@property(nonatomic, strong) APPSCurrentUser *user;

@end

@implementation APPSFacebookSignUpControllerConfigurator

static NSInteger const kNotYouButtonTag = 2;
static NSInteger const kFacebookNameLabelTag = 3;

- (instancetype)initWithUser:(APPSCurrentUser *)user {
  self = [super init];
  if (self) {
    _user = user;
  }
  return self;
}

- (NSString *)screenName {
  return @"Sign up/Sign in with Facebook";
}

- (void)configureNewUserSession:(APPSCurrentUser *)user {
  [super configureNewUserSession:user];
  user.showFacebookFriends = YES;
  user.newUser = NO;
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)performSegueOnViewController:(UIViewController *)controller {
  [[controller.navigationController.viewControllers firstObject]
      rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
           withSignals:[RACSignal return:kSignUpFacebookFriendsSegue],
                       [RACSignal return:controller], nil];
}

- (UIView *)tableHeaderView {
  return [[APPSFacebookSignUpTableHeaderView alloc] init];
}

- (void)setupInitialDataOnTabelHeaderView:(UIView *)headerView
                                viewModel:(APPSFacebookSignUpViewModel *)viewModel {
  [[SDWebImageManager sharedManager]
      downloadImageWithURL:
          [NSURL URLWithString:[self.user.avatar
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                   options:0
                  progress:NULL
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                             BOOL finished, NSURL *imageURL) {
                     if (image) {
                       [viewModel setUserImage:image];
                     } else if (finished) {
                       NSLog(@"%@", error);
                     }
                 }];
  UILabel *facebookNameLabel = (UILabel *)[headerView viewWithTag:kFacebookNameLabelTag];
  facebookNameLabel.text = self.user.facebookName;
  UIButton *notYouButton = (UIButton *)[headerView viewWithTag:kNotYouButtonTag];
  CGFloat notYouTitleFontSize = 11.0;
  NSAttributedString *notYouTitle = [[NSAttributedString alloc]
      initWithString:NSLocalizedString(@"Not You?", nil)
          attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:notYouTitleFontSize],
            NSForegroundColorAttributeName : UIColorFromRGB(254, 192, 192, 1.0),
            NSUnderlineStyleAttributeName : @1
          }];
  [notYouButton setAttributedTitle:notYouTitle forState:UIControlStateNormal];
  notYouButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
      return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
          [[FBSession activeSession] closeAndClearTokenInformation];
          return nil;
      }];
  }];
}

- (void)mainLogicWithViewController:(APPSRACStrategyTableViewController *)viewController
                          viewModel:(APPSFacebookSignUpViewModel *)viewModel {
  [super mainLogicWithViewController:viewController viewModel:viewModel];

  UIView *headerView = viewController.tableView.tableHeaderView;
  [self setupInitialDataOnTabelHeaderView:headerView viewModel:viewModel];

  @weakify(viewController);
  [[((UIButton *)[headerView viewWithTag:kNotYouButtonTag])
          .rac_command executionSignals] subscribeNext:^(RACSignal *commandSignal) {
      @strongify(viewController);
      UINavigationController *navigation = viewController.navigationController;
      [navigation popToRootViewControllerAnimated:NO];
      [[navigation.viewControllers firstObject] performSegueWithIdentifier:signUpSegue sender:self];
  }];
}

@end
