//
//  APPSAuthTableViewCell.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAuthTableViewCell.h"

@interface APPSAuthTableViewCell()
@property (assign, nonatomic) NSInteger numberOfShakes;
@property (assign, nonatomic) BOOL backwardsDirection;
@end

@implementation APPSAuthTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  CGFloat textFieldFont = 14;
  UIFont *font = [UIFont systemFontOfSize:textFieldFont];
  self.textField.font = font;
  self.textField.textColor = [UIColor whiteColor];
  self.textField.layer.borderColor = [UIColor whiteColor].CGColor;
  self.textField.layer.borderWidth = 2;
  self.textField.backgroundColor = [UIColor clearColor];
  self.textField.leftViewMode = UITextFieldViewModeAlways;
  self.textField.layer.cornerRadius = CGRectGetHeight(self.textField.frame) / 2.0;
  self.textField.clipsToBounds = YES;

  [self.textField rac_liftSelector:@selector(setReturnKeyType:)
                       withSignals:RACObserve(self, model.returnKeyType), nil];
  [self.textField rac_liftSelector:@selector(setSecureTextEntry:)
                       withSignals:RACObserve(self, model.secureTextEntry), nil];
  [self.textField rac_liftSelector:@selector(setKeyboardType:)
                       withSignals:RACObserve(self, model.keyboardType), nil];
  RAC(self.textField, attributedPlaceholder) =
      [[RACObserve(self, model.textFieldPlaceholder) ignore:nil] map:^id(NSString *placeholder) {
          return [[NSAttributedString alloc]
              initWithString:placeholder
                  attributes:@{
                    NSForegroundColorAttributeName : [UIColor whiteColor],
                    NSFontAttributeName : font
                  }];
      }];
  @weakify(self);
  RAC(self.textField, leftView) = [RACObserve(self, model.leftImage) map:^id(UIImage *value) {
      @strongify(self);
      UIImageView *imageView = [[UIImageView alloc] initWithImage:value];
      imageView.layer.cornerRadius = self.textField.layer.cornerRadius;
      imageView.clipsToBounds = YES;
      return imageView;
  }];
  RAC(self.textField, text) =
      [RACObserve(self, model.textFieldText) map:^id(id value) { return value; }];
  RAC(self.textField, backgroundColor) =
      [RACObserve(self, model.textFiledBackgroundColor) map:^id(id value) { return value; }];

  [self.textField.rac_textSignal subscribeNext:^(NSString *text) {
      @strongify(self);

      self.model.textFieldText = text;
  }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shakeWrongDataTextFieldIfNeeded:)
                                                 name:kShakeTextFieldNotificationName
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shakeWrongDataTextFieldIfNeeded:(NSNotification *)notification {
    if (!self.model.isFieldValid) {
        [self shakeWrongDataTextField];
    }
}

- (void)shakeWrongDataTextField {
    [UIView animateWithDuration:0.05
                     animations:^ {
                         self.textField.transform = CGAffineTransformMakeTranslation(5*self.backwardsDirection, 0);
                     }
                     completion:^(BOOL finished) {
                         if(self.numberOfShakes >= 5) {
                             self.numberOfShakes = 0;
                             self.textField.transform = CGAffineTransformIdentity;
                             return;
                         }
                         self.numberOfShakes++;
                         self.backwardsDirection = !self.backwardsDirection;
                         [self shakeWrongDataTextField];
                     }];

}

@end
