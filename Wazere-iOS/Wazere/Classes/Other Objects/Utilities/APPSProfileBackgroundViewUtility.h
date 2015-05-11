//
//  APPS.h
//  Wazere
//
//  Created by Petr Yanenko on 1/30/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSProfileBackgroundViewUtility : NSObject

- (CGRect)frameForBackgroundViewWithHeaderRect:(CGRect)headerRect
                             collectioViewRect:(CGRect)collectionViewFrame
                                 contentHeignt:(CGFloat)contentHeight;

@end
