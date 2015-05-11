//
//  FNViewController.h
//  flocknest
//
//  Created by Ostap on 12/12/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface APPSRACViewController : GAITrackedViewController

@end

@interface APPSRACViewController ()

@property(nonatomic, strong) UITapGestureRecognizer *keyboardTapRecognizer;

- (void)disposeViewController;
- (void)updateConstraintsForShownKeyboardBounds:(CGRect)keyboardBounds
                                 animationCurve:(UIViewAnimationCurve)curve;
- (void)updateConstraintsForHiddenKeyboardWithBounds:(CGRect)bounds
                                      animationCurve:(UIViewAnimationCurve)curve;
- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender;

@end
