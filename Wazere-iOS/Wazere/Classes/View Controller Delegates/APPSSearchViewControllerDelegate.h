//
//  APPSSearchViewControllerDelegate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSFollowListViewControllerDelegate.h"
#import "APPSSearchDisplayTableViewDelegate.h"
#import "APPSSegmentSuplementaryView.h"

@interface APPSSearchViewControllerDelegate
    : APPSFollowListViewControllerDelegate<APPSSearchDisplayTableViewDelegate,
                                           APPSSegmentSuplementaryViewDelegate>

@end
