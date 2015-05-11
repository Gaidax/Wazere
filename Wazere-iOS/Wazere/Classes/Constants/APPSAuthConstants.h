//
//  AuthConstants.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSAuthConstants_h
#define Wazere_APPSAuthConstants_h

static NSString *const SIGN_UP_TABLE_HEADER_VIEW = @"APPSSignUpTableHeaderView";
static NSString *const SIGN_IN_TABLE_HEADER_VIEW = @"APPSSignInTableHeaderView";
static NSString *const AUTH_TABLE_FOOTER_VIEW = @"APPSAuthTableViewFooterView";
static NSString *const SIGN_UP_BUTTON_IMAGE_NAME = @"login_but";
static NSString *const SIGN_UP_EMAIL_FIELD_LEFT_IMAGE_NAME = @"email-signIn";
static NSString *const SIGN_UP_USERNAME_FIELD_LEFT_IMAGE_NAME = @"username";
static NSString *const SIGN_UP_PASSWORD_FIELD_LEFT_IMAGE_NAME = @"password";
static NSString *const SIGN_UP_TEMPORARY_PASSWORD_FIELD_LEFT_IMAGE_NAME = @"tomp_password";

static NSString *const SIGN_UP_EMAIL_PLACEHOLDER = @"Enter email";
static NSString *const SIGN_UP_USERNAME_PLACEHOLDER = @"Create username";
static NSString *const SIGN_UP_PASSWORD_PLACEHOLDER = @"Create password";
static NSString *const SIGN_UP_CONFIRM_PASSWORD_PLACEHOLDER = @"Confirm password";

static NSString *const SIGN_IN_USERNAME_EMAIL_PLACEHOLDER = @"Enter username/email";
static NSString *const SIGN_IN_PASSWORD_PLACEHOLDER = @"Password";

static NSString *const kShakeTextFieldNotificationName = @"APPSShakeTextFieldNotificationName";

static NSString *const facebookTokenParamKey = @"fb_token";

static NSString *const signUpSegue = @"SignUpSegue";
static NSString *const signInSegue = @"SignInSegue";
static NSString *const facebookSignUpSegue = @"FacebookSignUpSegue";
static NSString *const kEulaWebViewSegue = @"APPSRACTableViewController-APPSWebViewController";

static NSString *const facebookSignUpMethod = @"GET";

static NSString *const mainScreenSegue = @"MainScreenSegue";
static NSString *const kSignUpFacebookFriendsSegue = @"StartViewController-FacebookViewController";
static NSString *const kSignUpOnboardingScreenSegue = @"StartViewController-OnboardingViewController";

static NSString *const updateUserCommandMethod = @"PUT";

static NSInteger const photoButtonTag = 1;
static NSInteger const forgetPasswordButtonTag = 12;
static NSInteger const mainButtonTag = 1;
static NSInteger const photoImageTag = 20;

#endif