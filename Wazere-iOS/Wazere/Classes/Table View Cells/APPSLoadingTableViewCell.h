//
//  APPSLoadingTableViewCell.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, APPSLoadingResultState) {
  APPSLoadingResultStateError,
  APPSLoadingResultStateNoResults,
  APPSLoadingResultStateNormal,
  APPSLoadingResultStateLoading
};

@interface APPSLoadingTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
