//
//  APPSResetPasswordAlert.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APPSResetPasswordAlertViewDelegate<NSObject>

@optional
- (void)okButtonDidTouch;

@end

@interface APPSResetPasswordAlertView : UIView

@property(weak, nonatomic) id<APPSResetPasswordAlertViewDelegate> delegate;

@end
