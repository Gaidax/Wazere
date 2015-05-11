//
//  APPSStartScreenViewController.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSStartScreenViewController.h"
#import "APPSStartScreenViewModel.h"
// Auth
#import "APPSAuthViewController.h"
// Sign up
#import "APPSSignUpViewControllerDelegate.h"
#import "APPSSignUpControllerConfigurator.h"
#import "APPSFacebookSignUpControllerConfigurator.h"
#import "APPSFacebookSignUpViewControllerDelegate.h"
#import "APPSFacebookSignUpViewModel.h"
// Sign in
#import "APPSSignInViewModel.h"
#import "APPSSignInViewControllerDelegate.h"
#import "APPSSignInViewControllerConfigurator.h"
// FacebookFriends
#import "APPSStrategyTableViewController.h"
#import "APPSSignUpFacebookSearchConfigurator.h"
#import "APPSSignUpFacebookSearchDelegate.h"

@interface APPSStartScreenViewController ()

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *facebookSignInButton;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *signUpButton;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *emailSignInButton;
@property(weak, NS_NONATOMIC_IOSONLY) UILabel *logoText;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIImageView *animationView;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet NSLayoutConstraint *bottomButtonsConstraint;
@property(assign, NS_NONATOMIC_IOSONLY) CGFloat normalButtonsConstraint;

@property(strong, NS_NONATOMIC_IOSONLY) APPSStartScreenViewModel *viewModel;

@end

@implementation APPSStartScreenViewController

- (NSString *)screenName {
  return @"Start screen";
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.viewModel = [[APPSStartScreenViewModel alloc] init];

  [self configureViews];

  [self handleFacebookSignInCommand];

  [self handleSignUpCommand];

  [self handleSignInCommand];

  [self handleSignUpFacebookFriendsSegue];
  [self startAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Views Configuring

- (void)configureViews {
  self.view.backgroundColor = kMainBackgroundColor;

  [self addLogoViews];

  [self.facebookSignInButton setTitle:NSLocalizedString(@"Login with Facebook", nil)
                             forState:UIControlStateNormal];
  [self.facebookSignInButton setTitleColor:kMainBackgroundColor forState:UIControlStateNormal];
  [self.signUpButton setTitle:NSLocalizedString(@"Register with Email", nil)
                     forState:UIControlStateNormal];
  [self.signUpButton setTitleColor:kMainBackgroundColor forState:UIControlStateNormal];
  [self.emailSignInButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
  [self.emailSignInButton setTitleColor:kMainBackgroundColor forState:UIControlStateNormal];
  self.facebookSignInButton.layer.cornerRadius = self.signUpButton.layer.cornerRadius =
      self.emailSignInButton.layer.cornerRadius =
          CGRectGetHeight(self.facebookSignInButton.frame) / 2.0;
  [self.view layoutIfNeeded];
  self.normalButtonsConstraint = self.bottomButtonsConstraint.constant;
  self.bottomButtonsConstraint.constant =
      -CGRectGetHeight(self.view.frame) + CGRectGetMinY(self.facebookSignInButton.frame);
}

- (void)addLogoViews {
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"APPSLogoImageView" owner:self options:nil];
  UIImageView *imageView = (UIImageView *)[views lastObject];
  imageView.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  CGFloat signInButtonBottomOffset = 30;
  imageView.frame =
      CGRectMake((self.view.bounds.size.width - imageView.bounds.size.width) / 2.0,
                 (self.facebookSignInButton.frame.origin.y - imageView.bounds.size.height -
                  (CGRectGetMaxY(self.emailSignInButton.frame) + signInButtonBottomOffset -
                   CGRectGetMaxY(self.view.frame))) /
                     2,
                 CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame));
  [self.view addSubview:imageView];
  UILabel *logoText = [[UILabel alloc] init];
  logoText.textAlignment = NSTextAlignmentCenter;
  logoText.textColor = [UIColor whiteColor];
  UIFont *logoFont = FONT_VOLTAIRE_REGULAR(55);
  logoText.font = logoFont;
  logoText.layer.shadowColor = UIColorFromRGB(148.0, 34.0, 30.0, 1.0).CGColor;
  logoText.layer.shadowOpacity = 1.0;
  logoText.layer.shadowRadius = 0.0;
  logoText.layer.shadowOffset = CGSizeMake(1.0, 2.0);
  logoText.text = NSLocalizedString(@"Wazere", nil);
  logoText.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:logoText];
  [self.view
      addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|[logoText]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(logoText)]];
  [self.view
      addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView]-[logoText]"
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(
                                                                         imageView, logoText)]];
  self.logoText = logoText;
  self.logoText.alpha = 0;
}

- (void)handleFacebookSignInCommand {
  self.facebookSignInButton.rac_command = self.viewModel.facebookSignInCommand;
  __block APPSCurrentUser *facebookSignInUser;

  @weakify(self);
  [[self.viewModel.facebookSignInCommand executionSignals]
      subscribeNext:^(RACSignal *commandSignal) {
          APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:self.view];
          [spinner startAnimating];

          @strongify(self);
          @weakify(spinner);
          [self.view endEditing:YES];
          self.facebookSignInButton.enabled = self.signUpButton.enabled =
              self.emailSignInButton.enabled = NO;
          [commandSignal subscribeNext:^(APPSCurrentUser *user) {
              @strongify(self);
              facebookSignInUser = user;
              NSString *segueIdentifier = nil;
              if (user.newUser) {
                segueIdentifier = facebookSignUpSegue;
              } else {
                segueIdentifier = mainScreenSegue;
                [[[APPSUtilityFactory sharedInstance] notificationUtility]
                    updateUserSessionForUser:user];
              }
              [self performSegueWithIdentifier:segueIdentifier sender:self];
              @strongify(spinner);
              [spinner stopAnimating];
          } error:^(NSError *error) {
              self.facebookSignInButton.enabled = self.signUpButton.enabled =
                  self.emailSignInButton.enabled = YES;
              @strongify(spinner);
              [spinner stopAnimating];
          } completed:^{
              self.facebookSignInButton.enabled = self.signUpButton.enabled =
                  self.emailSignInButton.enabled = YES;
              @strongify(spinner);
              [spinner stopAnimating];
          }];
      }];
  [[self rac_signalForSelector:@selector(prepareForSegue:sender:)]
      subscribeNext:^(RACTuple *parameters) {
          @strongify(self);
          UIStoryboardSegue *segue = (UIStoryboardSegue *)[parameters first];
          if ([[segue identifier] isEqualToString:facebookSignUpSegue]) {
            [self handleFacebookSignInSegue:segue withFacebookSignInUser:facebookSignInUser];
          }
      }];
}

- (void)handleFacebookSignInSegue:(UIStoryboardSegue *)segue
           withFacebookSignInUser:(APPSCurrentUser *)facebookSignInUser {
  APPSAuthViewController *destination = (APPSAuthViewController *)[segue destinationViewController];
  APPSFacebookSignUpViewModel *viewModel = [[APPSFacebookSignUpViewModel alloc] init];
  APPSFacebookSignUpViewControllerDelegate *delegate =
      [[APPSFacebookSignUpViewControllerDelegate alloc] initWithController:destination];
  delegate.viewModel = viewModel;
  destination.delegate = delegate;
  APPSFacebookSignUpControllerConfigurator *configurator =
      [[APPSFacebookSignUpControllerConfigurator alloc] initWithUser:facebookSignInUser];
  destination.mainLogicDelegate = configurator;
}

- (void)handleSignUpCommand {
  @weakify(self);
  self.signUpButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
      @strongify(self);
      return [self rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
                        withSignals:[RACSignal return:signUpSegue], [RACSignal return:self], nil];
  }];
  [[self rac_signalForSelector:@selector(prepareForSegue:sender:)]
      subscribeNext:^(RACTuple *parameters) {
          UIStoryboardSegue *segue = (UIStoryboardSegue *)[parameters first];
          if ([[segue identifier] isEqualToString:signUpSegue]) {
            APPSAuthViewController *destination =
                (APPSAuthViewController *)[segue destinationViewController];
            APPSSignUpViewModel *viewModel = [[APPSSignUpViewModel alloc] init];
            APPSSignUpViewControllerDelegate *delegate =
                [[APPSSignUpViewControllerDelegate alloc] initWithController:destination];
            delegate.viewModel = viewModel;
            APPSSignUpControllerConfigurator *conf =
                [[APPSSignUpControllerConfigurator alloc] init];
            destination.delegate = delegate;
            destination.mainLogicDelegate = conf;
          }
      }];
}

- (void)handleSignInCommand {
  @weakify(self);
  self.emailSignInButton.rac_command =
      [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id input) {
          @strongify(self);
          return
              [self rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
                         withSignals:[RACSignal return:signInSegue], [RACSignal return:self], nil];
      }];
  [[self rac_signalForSelector:@selector(prepareForSegue:sender:)]
      subscribeNext:^(RACTuple *parameters) {
          UIStoryboardSegue *segue = (UIStoryboardSegue *)[parameters first];
          if ([[segue identifier] isEqualToString:signInSegue]) {
            APPSAuthViewController *destination =
                (APPSAuthViewController *)[segue destinationViewController];
            APPSSignInViewModel *viewModel = [[APPSSignInViewModel alloc] init];
            APPSSignInViewControllerDelegate *delegate =
                [[APPSSignInViewControllerDelegate alloc] initWithController:destination];
            delegate.viewModel = viewModel;
            APPSSignInViewControllerConfigurator *conf =
                [[APPSSignInViewControllerConfigurator alloc] init];
            destination.delegate = delegate;
            destination.mainLogicDelegate = conf;
          }
      }];
}

- (void)handleSignUpFacebookFriendsSegue {
  [[self rac_signalForSelector:@selector(prepareForSegue:sender:)]
      subscribeNext:^(RACTuple *parameters) {
          UIStoryboardSegue *segue = (UIStoryboardSegue *)[parameters first];
          if ([segue.identifier isEqualToString:kSignUpFacebookFriendsSegue]) {
            APPSStrategyTableViewController *controller = (APPSStrategyTableViewController *)
                [[[segue destinationViewController] viewControllers] firstObject];
            controller.configurator = [[APPSSignUpFacebookSearchConfigurator alloc] init];
            APPSSignUpFacebookSearchDelegate *delegate =
                [[APPSSignUpFacebookSearchDelegate alloc] init];
            delegate.parentController = controller;
            controller.delegate = delegate;
            controller.dataSource = delegate;
          }
      }];
}

#pragma mark - Initial animation

- (void)startAnimation {
  NSInteger imagesCount = 50;
  NSMutableArray *images = [NSMutableArray arrayWithCapacity:imagesCount];
  for (unsigned long i = 1; i <= imagesCount; i++) {
    NSString *fullpath =
        [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%lu", i] ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    [images addObject:image];
  }
  CGFloat animationDuration = 4.0;
  self.animationView.animationImages = [images copy];
  self.animationView.animationDuration = animationDuration;
  self.animationView.animationRepeatCount = 1;
  [self.animationView startAnimating];
  [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                   target:self
                                 selector:@selector(fire:)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)fire:(NSTimer *)timer {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserIdKey]) {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
      // Session is created synchronically therefore handler is not needed
      [[[APPSUtilityFactory sharedInstance] facebookUtility] openSessionWithHandler:nil];
    }
    NSString *segueName;
    if ([[[APPSCurrentUserManager sharedInstance] currentUser] showFacebookFriends] == NO) {
      segueName = mainScreenSegue;
    } else {
      segueName = kSignUpFacebookFriendsSegue;
    }
    [self performSegueWithIdentifier:segueName sender:self];
  } else {
      [self performSegueWithIdentifier:kSignUpOnboardingScreenSegue sender:self];
  }
    
  [self.animationView stopAnimating];
  [self.view layoutIfNeeded];
  NSTimeInterval animationDuration = 1.0;
  [UIView animateWithDuration:animationDuration
      animations:^{
          self.animationView.frame = CGRectMake(
              CGRectGetMinX(self.animationView.frame), CGRectGetMinY(self.animationView.frame),
              CGRectGetWidth(self.animationView.frame),
              self.animationView.image.size.height * CGRectGetWidth(self.animationView.frame) /
                  self.animationView.image.size.width);
          self.bottomButtonsConstraint.constant = self.normalButtonsConstraint;
          self.logoText.alpha = 1.0;
          [self.view layoutIfNeeded];
      }
      completion:^(BOOL finished) {
          UIImage *lastAnimationImage = (UIImage *)[self.animationView.animationImages lastObject];
          self.animationView.image = lastAnimationImage;
          self.animationView.animationImages = nil;
      }];
}

@end
