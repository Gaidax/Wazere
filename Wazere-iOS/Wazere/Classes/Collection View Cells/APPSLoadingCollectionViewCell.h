//
//  APPSLoadingCollectionViewCell.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSProfileEmptyView.h"

@interface APPSLoadingCollectionViewCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) APPSProfileEmptyView *emptyView;

@end
