//
//  APPSFiltersViewControllerDelegate.h
//  Wazere
//
//  Created by Gaidax on 11/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyTableViewDelegate.h"
#import "APPSStrategyTableViewDataSource.h"

@protocol APPSFiltersSelectionDelegate<NSObject>
- (void)filterSelected:(NSString *)filter;
@end

@interface APPSFiltersViewControllerDelegate
    : NSObject<APPSStrategyTableViewDataSource, APPSStrategyTableViewDelegate>
- (instancetype)initWithTitles:(NSArray *)filterTitles
                      delegate:(id<APPSFiltersSelectionDelegate>)delegate;
@end
