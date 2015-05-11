//
//  APPSHashtagPhotosDelegate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileViewControllerDelegate.h"

@class APPSHashtagModel;

@interface APPSHashtagPhotosDelegate : APPSProfileViewControllerDelegate
@property(strong, nonatomic) APPSHashtagModel *hashtag;
@end
