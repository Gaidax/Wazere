//
//  APPSChooseAllTableHeaderView.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSearchTableHeaderView.h"
#import "APPSSharePhotoTextField.h"

@implementation APPSSearchTableHeaderView

- (void)awakeFromNib {
  self.searchTextField.rightViewMode = UITextFieldViewModeNever;
}

@end
