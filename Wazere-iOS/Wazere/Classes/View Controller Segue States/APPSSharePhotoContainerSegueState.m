//
//  APPSTopBarContainerSegueState.m
//  Wazere
//
//  Created by Petr Yanenko on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoContainerSegueState.h"

#import "APPSCameraConstants.h"

#import "APPSSharePhotoDelegate.h"
#import "APPSSharePhotoContainerDelegate.h"
#import "APPSSharePhotoSegueState.h"
#import "APPSSharePhotoViewConfigurator.h"

#import "APPSSharePhotoViewModel.h"

#import "APPSStrategyTableViewController.h"
#import "APPSTopBarContainerViewController.h"

@interface APPSSharePhotoContainerDelegate ()

@property(strong, nonatomic) RACSignal *saveSignal;

@end

@implementation APPSSharePhotoContainerSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kSharePhotoChildSegue]) {
    APPSSharePhotoContainerDelegate *sourceDelegate = (APPSSharePhotoContainerDelegate *)
        [(APPSTopBarContainerViewController *)[segue sourceViewController] delegate];
    APPSStrategyTableViewController *destination =
        (APPSStrategyTableViewController *)[segue destinationViewController];
    destination.configurator = [[APPSSharePhotoViewConfigurator alloc] init];
    destination.state = [[APPSSharePhotoSegueState alloc] init];
    APPSSharePhotoDelegate *delegate =
        [[APPSSharePhotoDelegate alloc] initWithPhoto:sourceDelegate.savedImage
                                     parentController:destination];
    APPSSharePhotoViewModel *viewModel = [[APPSSharePhotoViewModel alloc] init];
    delegate.viewModel = viewModel;
    destination.delegate = delegate;
    destination.dataSource = delegate;

    sourceDelegate.saveSignal = delegate.shareSignal;
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
