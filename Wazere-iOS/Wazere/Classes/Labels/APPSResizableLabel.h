//
//  APPSResizableLabel.h
//  Wazere
//
//  Created by Petr Yanenko on 11/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "PPLabel.h"

static CGFloat const kResizableLabelDefaultOffset = 2.0;

@interface APPSResizableLabel : PPLabel

@property(assign, NS_NONATOMIC_IOSONLY) CGFloat offset;

@end
