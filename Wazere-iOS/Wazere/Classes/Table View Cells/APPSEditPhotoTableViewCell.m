//
//  APPSSelectPhotoTableViewCell.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSEditPhotoTableViewCell.h"

@implementation APPSEditPhotoTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.changePhotoButton.layer.cornerRadius = CGRectGetHeight(self.changePhotoButton.frame) / 2.0;
  self.changePhotoButton.clipsToBounds = YES;
}

- (IBAction)changePhotoButtonPressed:(id)sender {
  if ([self.delegate respondsToSelector:@selector(takeNewPhoto)]) {
    [self.delegate takeNewPhoto];
  }
}

@end
