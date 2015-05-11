//
//  APPSNewsFeedSegueState.m
//  Wazere
//
//  Created by Gaidax on 12/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNewsFeedSegueState.h"
#import "APPSFacebookSearchConfigurator.h"
#import "APPSFacebookSearchDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSNewsFeedConstants.h"

@implementation APPSNewsFeedSegueState

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNewsFeedFacebookFriendsSegue]) {
        APPSStrategyTableViewController *controller = (APPSStrategyTableViewController *)[segue destinationViewController];
        controller.configurator = [[APPSFacebookSearchConfigurator alloc] init];
        APPSFacebookSearchDelegate *delegate = [[APPSFacebookSearchDelegate alloc] init];
        delegate.parentController = controller;
        controller.delegate = delegate;
        controller.dataSource = delegate;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

@end
