//
//  APPSFiltersViewController.h
//  Wazere
//
//  Created by iOS Developer on 9/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewController.h"
#import "APPSPhotoProcessingDelegate.h"

@interface APPSFiltersViewController : APPSViewController

@property(strong, nonatomic) UIImage *pickedImage;
@property(strong, nonatomic) UIImage *savedImage;
@property(weak, nonatomic) id<APPSPhotoProcessingDelegate> processingDelegate;

@end
