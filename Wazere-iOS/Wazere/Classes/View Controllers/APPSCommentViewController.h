//
//  APPSCommentViewController.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLKTextViewController.h"
#import "APPSPhotoModel.h"

@interface APPSCommentViewController : SLKTextViewController

@property(strong, nonatomic) APPSPhotoModel *photoModel;

- (instancetype)initWithPhotoModel:(APPSPhotoModel *)photoModel;

@end
