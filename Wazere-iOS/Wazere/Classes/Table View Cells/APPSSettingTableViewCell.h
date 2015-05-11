//
//  APPSSettingTableViewCell.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSSettingTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *settingTitle;
@property(weak, nonatomic) IBOutlet UILabel *settingValue;

@end
