//
//  APPSPageControl.m
//  Wazere
//
//  Created by Gaidax on 4/6/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSPageControl.h"

@interface APPSPageControl()
@property (strong, nonatomic) UIImage *activeImage;
@property (strong, nonatomic) UIImage *inactiveImage;
@end

@implementation APPSPageControl

- (instancetype)init {
    self = [super init];
    if (self) {
        _activeImage = [UIImage imageNamed:@"active_page"];
        _inactiveImage = [UIImage imageNamed:@"not_active_page"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateDots];
}

- (void)updateDots {
    [self.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex:idx]];
        if (idx == self.currentPage) dot.image = self.activeImage;
        else dot.image = self.inactiveImage;
    }];
}

- (UIImageView *)imageViewForSubview:(UIView *)view {
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]]) {
        for (UIView* subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:view.bounds];
            [view addSubview:dot];
        }
    } else {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end
