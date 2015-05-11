//
//  APPSHastagTableViewCell.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHastagTableViewCell.h"

@implementation APPSHastagTableViewCell

- (void)awakeFromNib {
  self.accessoryView = [[UIImageView alloc] initWithImage:IMAGE_WITH_NAME(@"cell_arrow")];
}

@end
