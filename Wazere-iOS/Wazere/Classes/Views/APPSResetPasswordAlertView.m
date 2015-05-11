//
//  APPSResetPasswordAlert.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSResetPasswordAlertView.h"

@interface APPSResetPasswordAlertView ()

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation APPSResetPasswordAlertView

- (instancetype)init {
  self = [super init];
  if (self) {
    NSArray *subviewArray =
        [[NSBundle mainBundle] loadNibNamed:@"APPSResetPasswordAlertView" owner:nil options:nil];
    APPSResetPasswordAlertView *view = subviewArray[0];
    return view;
  }

  return self;
}

- (void)awakeFromNib {
  _okButton.layer.shadowOpacity = 0.14;
  _okButton.layer.shadowRadius = 0.0;
  _okButton.layer.shadowOffset = CGSizeMake(3, 3);
  _okButton.layer.shadowColor = [UIColor blackColor].CGColor;
  _okButton.titleLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(16);
  _titleLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(16);
  _messageLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(16);
}

- (IBAction)okAtion:(id)sender {
  if ([self.delegate respondsToSelector:@selector(okButtonDidTouch)]) {
    [self.delegate okButtonDidTouch];
  }
}

@end
