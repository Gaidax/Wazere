//
//  APPSChooseAllTableViewCell.h
//  Wazere
//
//  Created by Gaidax on 12/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSSearchResultTableViewCell.h"

@interface APPSChooseAllTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIButton *chooseAllButton;
@property(weak, nonatomic) id<APPSSearchResultTableViewCellDelegate> delegate;
@end
