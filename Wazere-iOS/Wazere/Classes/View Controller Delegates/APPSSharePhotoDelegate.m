//
//  APPSSharePhotoDelegate.m
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoDelegate.h"
#import "APPSCameraConstants.h"
#import "APPSStrategyTableViewController.h"
#import "APPSSharePhotoModel.h"
#import "APPSSearchTableHeaderView.h"

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileSegueState.h"

#import "APPSNavigationViewController.h"
#import "APPSSomeUser.h"
#import "APPSSharePhotoTextField.h"
#import "APPSChooseAllTableViewCell.h"
#import "APPSRACBaseRequest.h"

@interface APPSSharePhotoDelegate () <UITextFieldDelegate>
@property(assign, NS_NONATOMIC_IOSONLY) BOOL isDetermineLocation;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL isFromMap;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL disableToShareLocation;
@end

@implementation APPSSharePhotoDelegate

@synthesize viewModel = _viewModel;
@synthesize parentController = _parentController;

- (instancetype)initWithPhoto:(UIImage *)photo
             parentController:(APPSStrategyTableViewController *)controller {
  self = [super init];
  if (self) {
    _parentController = controller;
    _shareModel = [[APPSSharePhotoModel alloc] init];
    _shareModel.isPublic = YES;
    if (photo == nil) {
      NSLog(@"%@", [NSError errorWithDomain:@"APPSSharePhotoDelegate"
                                       code:0
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"Photo is nil"
                                   }]);
      return nil;
    }
    _shareModel.images = @[ photo ];
    _shareSignal = [self shareSignal];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[[APPSUtilityFactory sharedInstance] locationUtility] stopUpdates];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self initWithPhoto:nil parentController:nil];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Share photo info";
}

- (RACSignal *)shareSignal {
  RACSignal *taglineSignal = RACObserve(self, shareModel.tagline);
  RACSignal *surpriseSignal = RACObserve(self, shareModel.isSurprise);
  RACSignal *descriptionSignal = RACObserve(self, shareModel.photoDescription);
  RACSignal *locationSignal = RACObserve(self, shareModel.location);
  @weakify(self);
  return [RACSignal
      combineLatest:@[ taglineSignal, surpriseSignal, descriptionSignal, locationSignal ]
             reduce:^id(NSString *tagline, NSNumber *isSurprise, NSString *description,
                        CLLocation *location) {

               @strongify(self);
               if (tagline.length && [isSurprise boolValue]) {
                 return nil;
               } else if (description.length > kMaxDescriptionLength) {
                 return nil;
               } else if (location == nil) {
                 return nil;
               } else {
                 return self.shareModel;
               }
             }];
}

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController {
  if (!self.isFromMap) {
    [self resetLocation];
    [self updateLocation];
  }
  self.isFromMap = NO;
  APPSSharePhotoHeader *header = (APPSSharePhotoHeader *)parentController.tableView.tableHeaderView;
  header.model = self.shareModel;
  header.locationAlias.enabled = !self.disableToShareLocation;
}


- (void)updateLocation {
  if (self.isDetermineLocation) {
    return;
  }
  self.isDetermineLocation = YES;
  @weakify(self);
  LocationManagerUtilityHandler handler = ^(CLLocation *location, NSError *error) {
    @strongify(self);
    if (location) {
      self.userLocation = location;
      self.shareModel.location = self.userLocation;
      APPSSharePhotoHeader *header =
          (APPSSharePhotoHeader *)self.parentController.tableView.tableHeaderView;
      header.model = self.shareModel;
    } else {
      NSLog(@"%@", error);
    }
    [[[APPSUtilityFactory sharedInstance] locationUtility] stopUpdates];
    self.isDetermineLocation = NO;
  };
  [[[APPSUtilityFactory sharedInstance] locationUtility]
      startStandardUpdatesWithDesiredAccuracy:kCLLocationAccuracyNearestTenMeters
                               distanceFilter:kUpdateLocationDistance
                                      handler:handler];
}

- (void)resetLocation {
  self.shareModel.location = nil;
  self.userLocation = nil;
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - APPSharePhotoHeaderDelegare

- (void)chooseNewLocationViewTouched {
  if (self.isDetermineLocation || self.disableToShareLocation) {
    return;
  }
  [self.parentController performSegueWithIdentifier:kChooseUserLocationSegue sender:self];
  self.isFromMap = YES;
}

- (void)changeShareLocationStatus:(BOOL)status {
  self.disableToShareLocation = !status;
  self.shareModel.hideLocation = self.disableToShareLocation;
  [self.parentController reloadTable];
}

@end
