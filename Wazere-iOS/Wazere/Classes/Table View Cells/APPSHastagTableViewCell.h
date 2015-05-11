//
//  APPSHastagTableViewCell.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSHastagTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *hashtagLabel;
@property(weak, nonatomic) IBOutlet UILabel *postsCountLabel;

@end
