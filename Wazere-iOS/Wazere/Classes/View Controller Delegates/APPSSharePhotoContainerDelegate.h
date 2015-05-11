//
//  APPSSharePhotoContainerDelegate.h
//  Wazere
//
//  Created by Petr Yanenko on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSViewControllerDelegate.h"
#import "APPSTopBarContainerDelegate.h"
#import "APPSPhotoProcessingDelegate.h"

@class APPSTopBarContainerViewController;

@interface APPSSharePhotoContainerDelegate : NSObject<APPSTopBarContainerViewControllerDelegate>

@property(weak, NS_NONATOMIC_IOSONLY) APPSTopBarContainerViewController *parentController;
@property(weak, NS_NONATOMIC_IOSONLY) id<APPSPhotoProcessingDelegate> processingDelegate;
@property(strong, NS_NONATOMIC_IOSONLY) UIImage *savedImage;

@end
