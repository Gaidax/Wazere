//
//  APPSUsernameEmailTableViewCellModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSUsernameEmailTableViewCellModel.h"

@implementation APPSUsernameEmailTableViewCellModel

- (void)validity {
  @weakify(self);
  [RACObserve(self, textFieldText) subscribeNext:^(NSString *usernameEmail) {
    @strongify(self);
    if (usernameEmail.length) {
        char lastCharacter = [usernameEmail characterAtIndex:usernameEmail.length - 1];
        NSCharacterSet *validatingSet = [NSCharacterSet alphanumericCharacterSet];
        if (![validatingSet characterIsMember:lastCharacter] && lastCharacter != '@' &&
            lastCharacter != '.' && lastCharacter != '-' && lastCharacter != '_') {
          self.textFieldText = [usernameEmail substringToIndex:usernameEmail.length - 1];
        }
      }
      self.isFieldValid = self.textFieldText.length >= 4;
      if (self.textFieldText.length >= 4) {
          self.textFiledBackgroundColor = [UIColor colorWithWhite:whiteColor alpha:alpha];
      } else {
          self.textFiledBackgroundColor = [UIColor clearColor];
      }
  }];
}

@end
