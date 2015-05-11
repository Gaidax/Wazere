//
//  APPSEditTextTableViewCell.h
//  Wazere
//
//  Created by Gaidax on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPSResizableTextView;

@interface APPSEditTextTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet APPSResizableTextView *textView;

@end
