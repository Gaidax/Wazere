//
//  APPSAuthTableViewCell.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APPSAuthTableViewCellModel.h"

@interface APPSAuthTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(strong, nonatomic) APPSAuthTableViewCellModel *model;
@property(strong, nonatomic) NSString *validationKeyPath;

- (void)shakeWrongDataTextField;
@end