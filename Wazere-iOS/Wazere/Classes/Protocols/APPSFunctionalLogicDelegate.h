//
//  ViewControllerConfiguratorProtocol.h
//  flocknest
//
//  Created by iOS Developer on 1/2/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSStrategyControllerDelegate.h"

@protocol APPSFunctionalLogicDelegate<NSObject, NSCoding>

- (void)mainLogicWithViewController:(UIViewController *)viewController
                          viewModel:(id<APPSCollectionViewModel>)viewModel;
- (NSString *)screenName;

@end
