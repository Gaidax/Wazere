//
//  APPSSettingsViewControllerDelegate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyTableViewDataSource.h"
#import "APPSStrategyTableViewDelegate.h"

@interface APPSSettingsViewControllerDelegate
    : NSObject<APPSStrategyTableViewDataSource, APPSStrategyTableViewDelegate>

- (NSString *)localizedCellTitleForIndex:(NSInteger)index;
+ (void)cleanUserDataAndShowStartScreen;

@end
