//
//  FNViewController.h
//  flocknest
//
//  Created by Ostap on 12/12/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol APPSViewControllerConfiguratorProtocol
, APPSSegueStateProtocol, APPSViewControllerDelegate;

@interface APPSViewController : GAITrackedViewController

@property(strong, NS_NONATOMIC_IOSONLY) id<APPSViewControllerConfiguratorProtocol> configurator;
@property(strong, NS_NONATOMIC_IOSONLY) id<APPSSegueStateProtocol> state;
@property(strong, NS_NONATOMIC_IOSONLY) id<APPSViewControllerDelegate> delegate;

@property(assign, NS_NONATOMIC_IOSONLY) BOOL disposeLeftButton;

- (NSString *)screenName;
@end

@interface APPSViewController ()

@property(strong, NS_NONATOMIC_IOSONLY) UITapGestureRecognizer *keyboardTapRecognizer;

- (void)disposeViewController;
- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender;
@end
