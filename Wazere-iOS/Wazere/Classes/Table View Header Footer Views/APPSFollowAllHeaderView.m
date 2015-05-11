//
//  APPSFollowAllHeaderView.m
//  Wazere
//
//  Created by Gaidax on 10/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFollowAllHeaderView.h"

@implementation APPSFollowAllHeaderView

- (IBAction)followAllAction:(id)sender {
  if ([self.delegate respondsToSelector:@selector(reusableView:followAction:)]) {
    [self.delegate reusableView:self followAction:sender];
  }
}

@end
