//
//  APPSSharePhotoViewConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoViewConfigurator.h"
#import "APPSStrategyTableViewController.h"
#import "APPSCameraConstants.h"
#import "APPSSharePhotoDelegate.h"

@implementation APPSSharePhotoViewConfigurator

- (void)configureViewController:(APPSStrategyTableViewController *)controller {
  [super configureViewController:controller];
  [self configureTableViewHeader:controller];
  controller.tableView.tableFooterView = [[UIView alloc] init];
  controller.tableView.clipsToBounds = YES;
}

- (void)configureTableViewHeader:(APPSStrategyTableViewController *)controller {
  APPSSharePhotoHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"APPSSharePhotoHeader"
                                                                owner:self
                                                              options:nil] firstObject];
  APPSSharePhotoDelegate *delegate = ((APPSSharePhotoDelegate *)controller.delegate);
  header.delegate = delegate;
  controller.tableView.tableHeaderView = header;
    controller.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;

  UINib *nib = [UINib nibWithNibName:@"APPSSearchTableHeaderView" bundle:nil];
  [controller.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:kSearchFriendsHeader];

  nib = [UINib nibWithNibName:@"APPSChooseAllTableViewCell" bundle:nil];
  [controller.tableView registerNib:nib forCellReuseIdentifier:kChooseAllFriendsCell];
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
