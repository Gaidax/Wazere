//
//  APPSSearchDisplayTableViewDelegate.h
//  Wazere
//
//  Created by Gaidax on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//
#import "APPSStrategyTableViewDelegate.h"

@protocol APPSSearchDisplayTableViewDelegate<APPSStrategyTableViewDelegate, UISearchBarDelegate>
- (void)searchNavigationBarButonPressed;
@end
