//
//  APPSPasswordTableViewCellModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPasswordTableViewCellModel.h"

@implementation APPSPasswordTableViewCellModel

- (void)validity {
  @weakify(self);
  [RACObserve(self, textFieldText) subscribeNext:^(NSString *password) {
      @strongify(self);
      if (password.length) {
        char lastCharacter = [password characterAtIndex:password.length - 1];
        NSCharacterSet *validatingSet = [NSCharacterSet alphanumericCharacterSet];
        if (![validatingSet characterIsMember:lastCharacter] && lastCharacter != '_') {
          self.textFieldText = [password substringToIndex:password.length - 1];
        }
      }
      
      self.isFieldValid = self.textFieldText.length > 0 && [self.textFieldText apps_isPasswordValid];
      if (self.isFieldValid) {
          self.textFiledBackgroundColor = [UIColor colorWithWhite:whiteColor alpha:alpha];
      } else {
          self.textFiledBackgroundColor = [UIColor clearColor];
      }
  }];
}

@end
