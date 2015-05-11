//
//  ViewControllerConfiguratorProtocol.h
//  flocknest
//
//  Created by iOS Developer on 1/2/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPSViewControllerConfiguratorProtocol<NSObject, NSCoding>

- (void)configureViewController:(UIViewController *)controller;
@optional
- (void)cleanUpViewController:(UIViewController *)controller;
- (void)configureSearchBar:(UISearchBar *)searchBar;

@end
