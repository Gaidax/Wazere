//
//  APPSProfileRightButtonStrategyProtocol.h
//  Wazere
//
//  Created by Petr Yanenko on 1/21/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

@class APPSProfileViewControllerDelegate;

@protocol APPSProfileRightButtonStrategyProtocol<NSObject>

@property(weak, nonatomic) APPSProfileViewControllerDelegate *parentDelegate;

- (instancetype)initWithDelegate:(APPSProfileViewControllerDelegate *)delegate;

- (void)rightNavigationButtonAction:(UIBarButtonItem *)sender;

@end
