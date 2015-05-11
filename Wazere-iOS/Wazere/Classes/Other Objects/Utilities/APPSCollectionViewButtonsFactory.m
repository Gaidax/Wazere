//
//  APPSCollectionViewButtonsFactory.m
//  Wazere
//
//  Created by iOS Developer on 10/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCollectionViewButtonsFactory.h"

@implementation APPSCollectionViewButtonsFactory

- (UIButton *)createCustomButtonWithFrame:(CGRect)frame
                                    image:(UIImage *)image
                         highlightedImage:(UIImage *)highlightedImage
                          backgroundColor:(UIColor *)color
                          backgroundImage:(UIImage *)backgroundImage
               highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = color;
  button.frame = frame;
  [button setImage:image forState:UIControlStateNormal];
  [button setImage:highlightedImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
  return button;
}

- (UIColor *)backgroundColor {
  return [UIColor colorWithRed:245.0 / 255 green:221.0 / 255 blue:214.0 / 255 alpha:1.0];
}

- (UIButton *)createGridButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector {
  UIButton *gridButton = [self createCustomButtonWithFrame:frame
                                                     image:IMAGE_WITH_NAME(@"grid_active")
                                          highlightedImage:IMAGE_WITH_NAME(@"new_grid")
                                           backgroundColor:[UIColor clearColor]
                                           backgroundImage:nil
                                highlightedBackgroundImage:IMAGE_WITH_NAME(@"active_tab")];

  [gridButton setImage:IMAGE_WITH_NAME(@"new_grid") forState:UIControlStateSelected];
  [gridButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  return gridButton;
}

- (UIButton *)createListButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector {
  UIButton *listButton = [self createCustomButtonWithFrame:frame
                                                     image:IMAGE_WITH_NAME(@"list_view_active")
                                          highlightedImage:IMAGE_WITH_NAME(@"list_view")
                                           backgroundColor:[UIColor clearColor]
                                           backgroundImage:nil
                                highlightedBackgroundImage:IMAGE_WITH_NAME(@"active_tab")];
  [listButton setImage:IMAGE_WITH_NAME(@"list_view") forState:UIControlStateSelected];
  [listButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  return listButton;
}

- (UIButton *)createLikeButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector {
  UIButton *likeButton =
      [self createCustomButtonWithFrame:frame
                                  image:[[APPSUtilityFactory sharedInstance].imageUtility
                                            imageNamed:@"like_botton_red"]
                       highlightedImage:nil
                        backgroundColor:[self backgroundColor]
                        backgroundImage:nil
             highlightedBackgroundImage:nil];
  [likeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  return likeButton;
}

- (UIButton *)createMapButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector {
  UIButton *mapButton =
      [self createCustomButtonWithFrame:frame
                                  image:[[APPSUtilityFactory sharedInstance].imageUtility
                                            imageNamed:@"map"]
                       highlightedImage:nil
                        backgroundColor:[self backgroundColor]
                        backgroundImage:nil
             highlightedBackgroundImage:nil];
  [mapButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  return mapButton;
}

- (UIButton *)createEmptyButtonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = [self backgroundColor];
  button.frame = frame;
  return button;
}

- (void)highlightButton:(UIButton *)button inSuperview:(UIView *)superview {
  for (UIButton *buttonView in superview.subviews) {
    if ([buttonView isKindOfClass:[UIButton class]]) {
      buttonView.selected = NO;
      [buttonView setBackgroundImage:IMAGE_WITH_NAME(@"active_tab") forState:UIControlStateNormal];
    }
  }
  button.selected = YES;
  [button setBackgroundImage:nil forState:UIControlStateNormal];
}

@end
