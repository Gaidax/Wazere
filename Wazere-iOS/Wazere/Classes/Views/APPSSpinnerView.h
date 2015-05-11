//
//  APPSSpinnerView.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSSpinnerView : UIView

- (instancetype)initWithSuperview:(UIView *)superview;

- (void)startAnimating;
- (void)stopAnimating;

@end
