//
//  APPSHastagPhotosConfigurator.m
//  Wazere
//
//  Created by Alexey Kalentyev on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHastagPhotosConfigurator.h"

#import "APPSHashtagModel.h"
@implementation APPSHastagPhotosConfigurator

- (void)configureViewController:(UIViewController *)controller {
  [super configureViewController:controller];
  controller.title = [NSString stringWithFormat:@"#%@", self.hashtag.name];
  controller.navigationItem.rightBarButtonItems = nil;
}

@end
