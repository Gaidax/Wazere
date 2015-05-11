//
//  APPSFiltersTableViewCell.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFiltersTableViewCell.h"

@implementation APPSFiltersTableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  NSString *imageName = [NSString stringWithFormat:@"%@%@%@", [self.textLabel.text lowercaseString],
                                                   @"_filter", selected ? @"_selected" : @""];
  self.imageView.image = IMAGE_WITH_NAME(imageName);

  if (selected) {
    self.textLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = kMainBackgroundColor;
  }
}

@end
