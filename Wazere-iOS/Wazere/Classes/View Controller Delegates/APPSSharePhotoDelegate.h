//
//  APPSSharePhotoDelegate.h
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSFollowListViewControllerDelegate.h"
#import "APPSSegmentSuplementaryView.h"
#import "APPSSharePhotoHeader.h"

@class APPSSharePhotoModel;

@interface APPSSharePhotoDelegate
    : NSObject<APPSStrategyTableViewDataSource, APPSStrategyTableViewDelegate,APPSharePhotoHeaderDelegare>

@property(strong, nonatomic) RACSignal *shareSignal;
@property(strong, nonatomic) APPSSharePhotoModel *shareModel;
@property(strong, nonatomic) CLLocation *userLocation;

- (instancetype)initWithPhoto:(UIImage *)photo
             parentController:
                 (APPSStrategyTableViewController *)controller NS_DESIGNATED_INITIALIZER;

@end
