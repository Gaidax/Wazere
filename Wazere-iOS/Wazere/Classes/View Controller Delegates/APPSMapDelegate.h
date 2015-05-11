//
//  APPSMapDelegate.h
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSMapViewController.h"
#import "APPSMapFiltersView.h"

@class APPSPinModel, APPSUserLocationAnnotation;

@interface APPSMapDelegate : NSObject<APPSMapDelegate>

@property(strong, NS_NONATOMIC_IOSONLY) APPSPinModel *selectedPin;

@property(strong, NS_NONATOMIC_IOSONLY) APPSUserLocationAnnotation *userLocation;
@property(assign, NS_NONATOMIC_IOSONLY) CLLocationCoordinate2D selectedPhotoCoordinate;

- (instancetype)initWithParentController:
        (APPSMapViewController *)controller NS_DESIGNATED_INITIALIZER;

- (void)tapsRightNavigationButton:(UIButton *)sender;

@end
