//
//  APPSEmailTableViewCellModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSEmailTableViewCellModel.h"

@implementation APPSEmailTableViewCellModel

- (void)validity {
  @weakify(self);
  [RACObserve(self, textFieldText) subscribeNext:^(NSString *email) {
    @strongify(self);
    self.isFieldValid = email.length > 0 && [email apps_isEmailValid];
    if (self.isFieldValid) {
        self.textFiledBackgroundColor = [UIColor colorWithWhite:whiteColor alpha:alpha];
    } else {
        self.textFiledBackgroundColor = [UIColor clearColor];
      }
  }];
}
@end
