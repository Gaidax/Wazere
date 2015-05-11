//
//  APPSProfileEmptyView.m
//  Wazere
//
//  Created by Gaidax on 12/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileEmptyView.h"

@interface APPSProfileEmptyView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewHeight;

@end

@implementation APPSProfileEmptyView

static NSInteger const topImageViewSide = 150;

- (void)setTopImageViewHidden:(BOOL)topImageViewHidden {
    _topImageViewHidden = topImageViewHidden;
    self.topImageView.hidden = topImageViewHidden;
    if (topImageViewHidden) {
        self.topImageViewHeight.constant = 0;
    } else {
        self.topImageViewHeight.constant = topImageViewSide;
    }
}

@end
