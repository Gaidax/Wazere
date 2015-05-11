//
//  APPSChooseAllTableViewCell.m
//  Wazere
//
//  Created by Alexey Kalentyev on 12/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSChooseAllTableViewCell.h"

@implementation APPSChooseAllTableViewCell

- (void)awakeFromNib {
  // Initialization code
}
- (IBAction)chooseAllButtonPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
  if ([self.delegate respondsToSelector:@selector(reusableView:followAction:)]) {
    [self.delegate reusableView:self followAction:sender];
  }
}

@end
