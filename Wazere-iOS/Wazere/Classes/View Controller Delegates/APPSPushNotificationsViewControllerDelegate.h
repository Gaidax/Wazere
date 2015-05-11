//
//  APPSPushNotificationsViewControllerDelegate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/20/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyTableViewDataSource.h"
#import "APPSStrategyTableViewDelegate.h"

@interface APPSPushNotificationsViewControllerDelegate
    : NSObject<APPSStrategyTableViewDataSource, APPSStrategyTableViewDelegate>

@end
