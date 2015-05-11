//
//  APPSEditProfileViewControllerDelegate.h
//  Wazere
//
//  Created by Gaidax on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyTableViewDelegate.h"
#import "APPSStrategyTableViewDataSource.h"

@interface APPSEditProfileViewControllerDelegate
    : NSObject<APPSStrategyTableViewDataSource, APPSStrategyTableViewDelegate>

- (void)handleDonePressed;
@end
