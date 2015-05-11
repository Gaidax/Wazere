//
//  APPSCropViewController.h
//  Wazere
//
//  Created by Gaidax on 12/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewController.h"
#import "APPSPhotoProcessingDelegate.h"

@class APPSCropViewController;
@interface APPSCropViewController : APPSViewController
@property(strong, nonatomic) UIImage *pickedImage;
@property(strong, nonatomic) UIImage *savedImage;
@property(weak, nonatomic) id<APPSPhotoProcessingDelegate> processingDelegate;
@end
