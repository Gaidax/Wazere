//
//  ViewControllerDelegate.h
//  flocknest
//
//  Created by iOS Developer on 2/10/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPSViewControllerDelegate<NSObject, NSCoding>
- (NSString *)screenName;
@optional
- (void)disposeViewController:(UIViewController *)viewController;
- (BOOL)viewController:(UIViewController *)viewController
    shouldPerformSegueWithIdentifier:(NSString *)identifier
                              sender:(id)sender;

@end
