//
//  APPSCameraMapConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCameraMapConfigurator.h"
#import "APPSMapViewController.h"
#import "APPSCameraMapDelegate.h"

@interface APPSCameraMapDelegate ()

- (void)tapsDoneButton:(UIButton *)sender;

@end

@implementation APPSCameraMapConfigurator

- (void)configureViewController:(APPSMapViewController *)controller {
  controller.title = NSLocalizedString(@"Choose a location", nil);
  [controller.filtersView removeFromSuperview];

  [self configureSearchBar:controller.searchBar];

  controller.topMapViewConstraint.constant = 0;

  CGFloat buttonSize = 44.0;
  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  rightButton.frame = CGRectMake(0, 0, buttonSize, buttonSize);
  rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [rightButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];

  [rightButton addTarget:controller.delegate
                  action:@selector(tapsDoneButton:)
        forControlEvents:UIControlEventTouchUpInside];

  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
  controller.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configureSearchBar:(UISearchBar *)searchBar {
  searchBar.backgroundColor = [UIColor clearColor];
  searchBar.tintColor = kMainBackgroundColor;
  UIView *searchBarContainer = [searchBar.subviews firstObject];
  for (UIView *subview in searchBarContainer.subviews) {
    if ([subview isMemberOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [subview setBackgroundColor:[UIColor blackColor]];
      [subview setOpaque:NO];
      [subview setAlpha:0.75];
    } else if ([subview isKindOfClass:[UITextField class]]) {
      [(UITextField *)subview setReturnKeyType:UIReturnKeyDone];
    }
  }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

@end
