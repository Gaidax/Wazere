//
//  APPSTabbarBubble.h
//  Wazere
//
//  Created by Gaidax on 11/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, APPSTabbarBubbleStyle) {
  APPSTabbarBubbleStyleLike,
  APPSTabbarBubbleStyleFollow,
  APPSTabbarBubbleStyleComment,
  APPSTabbarBubbleStylePhoto
};

static CGFloat const imageSideSize = 48.f;

@interface APPSTabbarBubble : UIView

@property(strong, nonatomic) UIImageView *imageView;
@property(assign, nonatomic) APPSTabbarBubbleStyle bubbleStyle;

- (instancetype)initWithXPosition:(CGFloat)xPosition;
- (void)showBubbleWithStyle:(NSString *)style;
@end
