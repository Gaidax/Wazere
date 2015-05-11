//
//  APPSSettingTableViewCell.m
//  Wazere
//
//  Created by Gaidax on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSettingTableViewCell.h"

@implementation APPSSettingTableViewCell

- (void)awakeFromNib {
  self.accessoryView = [[UIImageView alloc] initWithImage:IMAGE_WITH_NAME(@"cell_arrow")];
}

@end
