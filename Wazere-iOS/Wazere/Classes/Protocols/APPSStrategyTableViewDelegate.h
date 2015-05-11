//
//  APPSStrategyTableViewControllerDelegate.h
//  Wazere
//
//  Created by Petr Yanenko on 10/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewControllerDelegate.h"

@protocol APPSStrategyTableViewDelegate<APPSViewControllerDelegate, UITableViewDelegate>
@optional
;
- (void)updateContentOffsetForKeyboardBounds:(CGRect)keyboardBounds
                           normalTableInsets:(UIEdgeInsets)normalTableInsets;
@end
