//
//  APPSCameraViewController.h
//  Wazere
//
//  Created by Petr Yanenko on 9/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewController.h"
#import "APPSPhotoProcessingDelegate.h"

@interface APPSCameraViewController : APPSViewController<UIImagePickerControllerDelegate,
                                                            UINavigationControllerDelegate,
                                                            APPSPhotoProcessingDelegate>

@property(strong, NS_NONATOMIC_IOSONLY) UIImagePickerController *pickerController;

@end
