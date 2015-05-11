//
//  APPSLoadingCollectionViewCell.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSLoadingCollectionViewCell.h"

@implementation APPSLoadingCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  APPSProfileEmptyView* emptyView =
      [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([APPSProfileEmptyView class])
                                     owner:nil
                                   options:nil] firstObject];
  emptyView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:emptyView];
  [self.contentView
      addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"V:|[emptyView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(emptyView)]];
  [self.contentView
      addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|[emptyView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(emptyView)]];
  self.emptyView = emptyView;
}

@end
