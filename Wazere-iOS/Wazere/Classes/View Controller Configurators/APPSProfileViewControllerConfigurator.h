//
//  APPSProfileViewControllerConfigurator.h
//  Wazere
//
//  Created by Bogdan Bilonog on 10/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSViewControllerConfiguratorProtocol.h"

@class APPSProfileViewController;

@interface APPSProfileViewControllerConfigurator : NSObject<APPSViewControllerConfiguratorProtocol>

@end

// protected
@interface APPSProfileViewControllerConfigurator ()

@property(weak, NS_NONATOMIC_IOSONLY) APPSProfileViewController *viewController;

- (void)addRefreshControl;
- (void)registerClasses;
- (void)addBackgroundOnCollectionView;

@end
