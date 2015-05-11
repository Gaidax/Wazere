//
//  APPSPinPhotosController.h
//  Wazere
//
//  Created by iOS Developer on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewController.h"

@class APPSPinModel;

@interface APPSPinPhotosController : APPSViewController

@property(strong, NS_NONATOMIC_IOSONLY) NSArray *photos;
@property(strong, NS_NONATOMIC_IOSONLY) APPSPinModel *pin;

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIView *gridView;

@end
