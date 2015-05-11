//
//  APPSLeftBarButtonsUtility.m
//  Wazere
//
//  Created by iOS Developer on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSLeftBarButtonsUtility.h"
#import "APPSViewController.h"

@implementation APPSLeftBarButtonsUtility

- (NSArray *)leftBarButtonItemsWithTarget:(APPSViewController *)target {
  UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat buttonSize = 44;
  leftButton.frame = CGRectMake(0, 0, buttonSize, buttonSize);
  UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
  UIBarButtonItem *fixedSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                    target:nil
                                                    action:NULL];
  fixedSpace.width = -10;
  [leftButton
      setImage:[[[APPSUtilityFactory sharedInstance] imageUtility] imageNamed:backArrowImageName]
      forState:UIControlStateNormal];
  [leftButton setImage:[[[APPSUtilityFactory sharedInstance] imageUtility]
                           imageNamed:backArrowClickedImageName]
              forState:UIControlStateHighlighted];
  [leftButton addTarget:target
                 action:@selector(disposeViewController)
       forControlEvents:UIControlEventTouchUpInside];
  leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  return @[ fixedSpace, leftItem ];
}

@end
