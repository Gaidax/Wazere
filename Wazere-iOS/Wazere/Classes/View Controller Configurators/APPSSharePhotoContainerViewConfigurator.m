//
//  APPSTopBarContainerViewConfigurator.m
//  Wazere
//
//  Created by Petr Yanenko on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoContainerViewConfigurator.h"
#import "APPSTopBarContainerViewController.h"
#import "APPSCameraConstants.h"

@implementation APPSSharePhotoContainerViewConfigurator

- (void)configureViewController:(APPSTopBarContainerViewController *)controller {
  controller.view.backgroundColor = kMainBackgroundColor;
  UIImage *closeImage = [UIImage imageNamed:backArrowImageName];
  if (closeImage == nil) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSSharePhotoContainerViewConfigurator"
                                     code:1
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Close image not loaded"
                                 }]);
  }
  UIImage *closeClickedImage = [UIImage imageNamed:backArrowClickedImageName];
  if (closeClickedImage == nil) {
    NSLog(@"%@",
          [NSError errorWithDomain:@"APPSSharePhotoContainerViewConfigurator"
                              code:2
                          userInfo:@{
                            NSLocalizedFailureReasonErrorKey : @"Clicked close image not loaded"
                          }]);
  }
  [controller.leftBarButton setImage:closeImage forState:UIControlStateNormal];
  [controller.leftBarButton setImage:closeClickedImage forState:UIControlStateHighlighted];
  [controller.centerBarButton setTitle:NSLocalizedString(@"Share Photo", nil)
                              forState:UIControlStateNormal];
  controller.centerBarButton.titleLabel.font =
      FONT_CHAMPAGNE_LIMOUSINES_BOLD(barBattonItemFontSize);
  [controller.rightBarButton setTitle:NSLocalizedString(@"Share", nil)
                             forState:UIControlStateNormal];
  controller.rightBarButton.titleLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(barBattonItemFontSize);
  [controller performSegueWithIdentifier:kSharePhotoChildSegue sender:self];
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
