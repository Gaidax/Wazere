//
//  APPSUserNameTableViewCellModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSUsernameTableViewCellModel.h"

@implementation APPSUsernameTableViewCellModel

- (void)validity {
  @weakify(self);
  [RACObserve(self, textFieldText) subscribeNext:^(NSString *username) {
    @strongify(self);
    if (username.length) {
        char lastCharacter = [username characterAtIndex:username.length - 1];
        NSCharacterSet *validatingSet = [NSCharacterSet alphanumericCharacterSet];
        if (![validatingSet characterIsMember:lastCharacter]) {
          self.textFieldText = [username substringToIndex:username.length - 1];
        }
      }
      
      self.isFieldValid = self.textFieldText.length > 0 && [self.textFieldText apps_isNameValid];
      if (self.isFieldValid) {
          self.textFiledBackgroundColor = [UIColor colorWithWhite:whiteColor alpha:alpha];
      } else {
        self.textFiledBackgroundColor = [UIColor clearColor];
      }
  }];
}

@end
