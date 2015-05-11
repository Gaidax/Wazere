//
//  APPSFacebookSignUpTableHeaderView.m
//  Wazere
//
//  Created by Petr Yanenko on 1/22/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSFacebookSignUpTableHeaderView.h"

@implementation APPSFacebookSignUpTableHeaderView

static NSString *const kFacebookSignUpNameView = @"APPSAuthFacebookNameView";

- (instancetype)init {
  self = [super init];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    UIView *photoView = [[[NSBundle mainBundle] loadNibNamed:SIGN_UP_TABLE_HEADER_VIEW
                                                            owner:nil
                                                          options:nil] firstObject];
    [photoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView *nameView = [[[NSBundle mainBundle] loadNibNamed:kFacebookSignUpNameView
                                                      owner:nil
                                                    options:nil] firstObject];
    [nameView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:photoView];
    [self addSubview:nameView];
    NSDictionary *views = NSDictionaryOfVariableBindings(photoView, nameView);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:
                          [NSString stringWithFormat:@"V:|[photoView(%f)][nameView]|",
                           CGRectGetHeight(photoView.frame)]
                          options:0
                          metrics:nil
                          views:views]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[photoView]|"
                          options:0
                          metrics:nil
                          views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    self.photoHeaderView = photoView;
    self.facebookNameView = nameView;
    self.frame = CGRectMake(0, 0, 0, CGRectGetHeight(photoView.frame) + CGRectGetHeight(nameView.frame));
  }
  return self;
}

@end
