//
//  APPSCollectionViewButtonsFactory.h
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSCollectionViewButtonsFactory : NSObject

- (UIButton *)createGridButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
- (UIButton *)createListButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
- (UIButton *)createMapButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
- (UIButton *)createLikeButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
- (UIButton *)createEmptyButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;

- (UIButton *)createCustomButtonWithFrame:(CGRect)frame
                                    image:(UIImage *)image
                         highlightedImage:(UIImage *)highlightedImage
                          backgroundColor:(UIColor *)color
                          backgroundImage:(UIImage *)backgroundImage
               highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage;

- (void)highlightButton:(UIButton *)button inSuperview:(UIView *)superview;

@end
