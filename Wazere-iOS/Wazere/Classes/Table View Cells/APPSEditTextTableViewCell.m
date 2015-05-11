//
//  APPSEditTextTableViewCell.m
//  Wazere
//
//  Created by Gaidax on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSEditTextTableViewCell.h"
#import "APPSResizableTextView.h"

@implementation APPSEditTextTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.textView.layer.cornerRadius = CGRectGetHeight(self.textView.frame) / 2.0;
  self.textView.clipsToBounds = YES;
}

@end
