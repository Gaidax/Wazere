//
//  APPSMapDelegate.m
//  Wazere
//
//  Created by iOS Developer on 9/26/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapDelegate.h"
#import "APPSPinRequest.h"
#import "APPSMapViewAnnotation.h"
#import "KPAnnotation.h"
#import "APPSAPIMapConstants.h"
#import "APPSTabBarViewController.h"
#import "APPSUserLocationAnnotation.h"
#import "APPSPinModel.h"
#import "CLLocation+NaN.h"

@interface APPSMapDelegate ()

@property(strong, NS_NONATOMIC_IOSONLY) APPSRACBaseRequest *pinRequest;
@property(strong, NS_NONATOMIC_IOSONLY) NSArray *places;
@property(strong, NS_NONATOMIC_IOSONLY) APPSPhotosModel *photosModel;
@property(strong, NS_NONATOMIC_IOSONLY) NSArray *selectedAnnotations;
@property(strong, NS_NONATOMIC_IOSONLY) NSString *currentFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSString *currentDateFilter;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL didShowSelectedPhotoLocation;

- (void)calculateOutRadius:(CLLocationDistance *)outRadius
               outLatitude:(CLLocationDegrees *)outLatitude
              outLongitude:(CLLocationDegrees *)outLongitude
                withRegion:(MKCoordinateRegion)region;
- (void)loadPlacesWithLatitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude
                        radius:(CLLocationDistance)radius
                        filter:(NSString *)filter
                    dateFilter:(NSString *)dateFilter
                          page:(NSInteger)page;
- (NSMutableArray *)createAnnotationsWithPlaces:(NSArray *)places;

@end

@implementation APPSMapDelegate

@synthesize parentController = _parentController;

- (instancetype)initWithParentController:(APPSMapViewController *)controller {
  self = [super init];
  if (self) {
    _parentController = controller;
    [self initializeSelectedPhotoCoordinate];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self initWithParentController:nil];
  if (self) {
  }
  return self;
}

- (NSString *)screenName {
  return @"Nearby screen";
}

- (void)dealloc {
  [[[APPSUtilityFactory sharedInstance] locationUtility] stopUpdates];
  [_pinRequest cancel];
}

- (void)tapsRightNavigationButton:(UIButton *)sender {
  APPSUserLocationAnnotation *userLocation = self.userLocation;
  if (userLocation.coordinate.latitude > 90.0 || userLocation.coordinate.latitude < -90.0 ||
      userLocation.coordinate.longitude > 180.0 || userLocation.coordinate.longitude < -180.0) {
    return;
  }
  [self.parentController performSegueWithIdentifier:kNearbyPhotosSegue sender:self];
}

- (void)disposeViewController:(UIViewController *)viewController {
  [[APPSTabBarViewController rootViewController] showMapPreviousTab];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (void)initializeSelectedPhotoCoordinate {
  CGFloat invalidLatitude = 100.0, invalidLongitude = 200.0;
  self.selectedPhotoCoordinate = CLLocationCoordinate2DMake(invalidLatitude, invalidLongitude);
}

#pragma mark - <APPSMapFiltersViewDelegate>

- (void)mapViewController:(APPSMapViewController *)controller
           mapFiltersView:(APPSMapFiltersView *)filtersView
             selectFilter:(NSString *)filter
               dateFilter:(NSString *)dateFilter {
  self.currentDateFilter = dateFilter;
  self.currentFilter = filter;
  [self loadPlaces];
}

#pragma mark MKMapViewDelegate

- (void)mapViewControllerWillAppear:(APPSMapViewController *)controller {
  @weakify(self);
  [[[APPSUtilityFactory sharedInstance] locationUtility]
      startStandardUpdatesWithDesiredAccuracy:kCLLocationAccuracyNearestTenMeters
                               distanceFilter:kFollowKillRoyUpdateDistance
                                      handler:^(CLLocation *location, NSError *error) {
                                          @strongify(self);
                                          if (location) {
                                            [self updateUserLocation:location];
                                          }
                                      }];
}

- (void)mapViewControllerWillDisappear:(APPSMapViewController *)controller {
  [[[APPSUtilityFactory sharedInstance] locationUtility] stopUpdates];
  [self initializeSelectedPhotoCoordinate];
  self.didShowSelectedPhotoLocation = NO;
}

- (void)checkSelectedPhotoLocation {
  BOOL isLocationValid = CLLocationCoordinate2DIsValid(self.selectedPhotoCoordinate);
  if (!self.didShowSelectedPhotoLocation && self.parentController.mapView && isLocationValid) {
    self.parentController.mapView.region = MKCoordinateRegionMakeWithDistance(
        self.selectedPhotoCoordinate, kRadius * 2.0, kRadius * 2.0);
    self.didShowSelectedPhotoLocation = YES;
  }
}

- (void)checkNearbyButton {
  if (self.parentController.navigationItem.rightBarButtonItem.customView.hidden &&
      self.userLocation) {
    self.parentController.navigationItem.rightBarButtonItem.customView.hidden = NO;
  }
}

- (void)setSelectedPhotoCoordinate:(CLLocationCoordinate2D)selectedPhotoCoordinate {
  if (_selectedPhotoCoordinate.latitude != selectedPhotoCoordinate.latitude ||
      _selectedPhotoCoordinate.longitude != selectedPhotoCoordinate.longitude) {
    _selectedPhotoCoordinate = selectedPhotoCoordinate;
    [self checkSelectedPhotoLocation];
  }
}

- (void)updateUserLocation:(CLLocation *)location {
  if (self.userLocation == nil) {
    self.userLocation =
        [[APPSUserLocationAnnotation alloc] initWithTitle:@"YOU'RE HERE"
                                                 subtitle:nil
                                            andCoordinate:CLLocationCoordinate2DMake(0, 0)];
  }
  CLLocationCoordinate2D userCoordinate = location.coordinate;
  CLLocationCoordinate2D previousCoordinate = self.userLocation.coordinate;
  [self.userLocation setCoordinate:userCoordinate];
  if (self.parentController.mapView) {
    NSUInteger userLocationIndex =
        [self.parentController.mapView.annotations indexOfObject:self.userLocation];
    if (userLocationIndex == NSNotFound) {
      [self.parentController.mapView addAnnotation:self.userLocation];
    }
    [self checkNearbyButton];
    BOOL shouldSetRegion = [[[CLLocation alloc] initWithLatitude:previousCoordinate.latitude
                                                       longitude:previousCoordinate.longitude]
                               distanceFromLocation:location] >= kFollowKillRoyUpdateDistance;
    if (!CLLocationCoordinate2DIsValid(self.selectedPhotoCoordinate) && shouldSetRegion) {
      MKCoordinateRegion region;
      region = MKCoordinateRegionMakeWithDistance(userCoordinate, kRadius * 2.0, kRadius * 2.0);
      [self.parentController.mapView setRegion:region animated:YES];
    }
    [self.parentController.mapView removeOverlays:self.parentController.mapView.overlays];
    MKCircle *circleOverlay =
        [MKCircle circleWithCenterCoordinate:userCoordinate radius:kOverlayRadius];
    [self.parentController.mapView addOverlay:circleOverlay];
  }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  [self updateUserLocation:userLocation.location];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  NSUInteger userLocationIndex =
      [self.parentController.mapView.annotations indexOfObject:self.userLocation];
  if (self.userLocation && userLocationIndex == NSNotFound) {
    [self updateUserLocation:[[CLLocation alloc]
                                 initWithLatitude:self.userLocation.coordinate.latitude
                                        longitude:self.userLocation.coordinate.longitude]];
  }
  [self checkNearbyButton];
  [self checkSelectedPhotoLocation];
  MKCoordinateRegion region = mapView.region;
  [self loadPlacesWithRegion:region];
}

- (void)loadPlaces {
  [self loadPlacesWithRegion:self.parentController.mapView.region];
}

- (void)loadPlacesWithRegion:(MKCoordinateRegion)region {
  CLLocationDistance radius;
  CLLocationDegrees latitude, longitude;
  [self calculateOutRadius:&radius outLatitude:&latitude outLongitude:&longitude withRegion:region];
  [self loadPlacesWithLatitude:latitude
                     longitude:longitude
                        radius:radius
                        filter:self.currentFilter
                    dateFilter:self.currentDateFilter
                          page:1];
}

- (void)calculateOutRadius:(CLLocationDistance *)outRadius
               outLatitude:(CLLocationDegrees *)outLatitude
              outLongitude:(CLLocationDegrees *)outLongitude
                withRegion:(MKCoordinateRegion)region {
  CLLocationCoordinate2D center = region.center;
  CLLocationDegrees latitude = center.latitude;
  CLLocationDegrees longitude = center.longitude;
  MKCoordinateSpan span = region.span;
  CLLocationDegrees northLatitude = center.latitude + span.latitudeDelta * 0.5;
  CLLocationDegrees southLatitude = center.latitude - span.latitudeDelta * 0.5;
  CLLocationDegrees eastLongitude = center.longitude + span.longitudeDelta * 0.5;
  CLLocationDegrees westLongitude = center.longitude - span.longitudeDelta * 0.5;
  CLLocation *north =
      [[CLLocation alloc] initWithLatitude:northLatitude longitude:region.center.longitude];
  CLLocation *south =
      [[CLLocation alloc] initWithLatitude:southLatitude longitude:region.center.longitude];
  CLLocation *east =
      [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:eastLongitude];
  CLLocation *west =
      [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:westLongitude];
  CLLocationDistance latitudeDeltaMeters = [north distanceFromLocation:south];
  CLLocationDistance longitudeDeltaMeters = [east distanceFromLocation:west];
  if (isnan(latitudeDeltaMeters) || isnan(longitudeDeltaMeters)) {
    latitudeDeltaMeters = [north apps_distanceFromLocation:south];
    longitudeDeltaMeters = [east apps_distanceFromLocation:west];
  }
  CLLocationDistance radius =
      (latitudeDeltaMeters > longitudeDeltaMeters ? latitudeDeltaMeters : longitudeDeltaMeters) /
      2.0;

  *outRadius = radius;
  *outLatitude = latitude;
  *outLongitude = longitude;
}

- (void)loadPlacesWithLatitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude
                        radius:(CLLocationDistance)radius
                        filter:(NSString *)filter
                    dateFilter:(NSString *)dateFilter
                          page:(NSInteger)page {
  [self.pinRequest cancel];
  if (filter == nil) {
    return;
  }
  NSDictionary *params = @{
    @"lat" : @(latitude),
    @"long" : @(longitude),
    @"radius" : @(radius),
    @"filter" : filter,
    @"page" : @(page)
  };
  if (dateFilter) {
    NSMutableDictionary *mutableParams = [params mutableCopy];
    mutableParams[@"date_filter"] = dateFilter;
    params = [mutableParams copy];
  }
  APPSPinRequest *request = [[APPSPinRequest alloc] initWithObject:nil
                                                            params:params
                                                            method:HTTPMethodGET
                                                           keyPath:kMapKeyPath
                                                        disposable:nil];
  RACSignal *currentRequestSignal = [request execute];
  @weakify(self);
  [[currentRequestSignal catch:^RACSignal * (NSError * error) {
      NSLog(@"%@", error);
      return [RACSignal empty];
  }] subscribeNext:^(APPSPhotosModel *photosModel) {
      @strongify(self);
      self.photosModel = photosModel;
      self.selectedAnnotations = self.parentController.mapView.selectedAnnotations;
      self.places = [self createPlacesWithPhotos:photosModel.photos];
      [self.parentController.clusteringController
          setAnnotations:[self createAnnotationsWithPlaces:self.places]];
      if (photosModel.currentPage < photosModel.totalPages) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadPlacesWithLatitude:latitude
                               longitude:longitude
                                  radius:radius
                                  filter:filter
                              dateFilter:self.currentDateFilter
                                    page:photosModel.currentPage + 1];
        });
      }
  }];
  self.pinRequest = request;
}

- (NSArray *)createPlacesWithPhotos:(NSArray *)photos {
  if (self.photosModel.currentPage == 1) {
    self.places = nil;
  }
  NSMutableArray *mutablePlaces = (NSMutableArray *)[self.places mutableCopy];
  if (mutablePlaces == nil) {
    mutablePlaces = [[NSMutableArray alloc] initWithCapacity:photos.count];
  }
  for (APPSPhotoModel *photo in photos) {
    BOOL notFound = YES;
    for (NSInteger i = 0; i < mutablePlaces.count; i++) {
      APPSPinModel *place = (APPSPinModel *)mutablePlaces[i];
      if (photo.place.pinId == place.pinId) {
        place.photos =
            (NSArray<APPSPhotoModel, Ignore> *)[[place.photos arrayByAddingObject:photo]
                sortedArrayUsingDescriptors:
                    @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES] ]];
        notFound = NO;
        break;
      }
    }
    if (notFound) {
      [mutablePlaces addObject:[[APPSPinModel alloc] initWithPhoto:photo]];
    }
  }
  return [mutablePlaces copy];
}

- (NSMutableArray *)createAnnotationsWithPlaces:(NSArray *)places {
  NSMutableArray *annotations = [[NSMutableArray alloc] init];
  for (APPSPinModel *pinModel in places) {
    CLLocationCoordinate2D coord;
    coord.latitude = pinModel.latitude;
    coord.longitude = pinModel.longitude;
    APPSMapViewAnnotation *annotation =
        [[APPSMapViewAnnotation alloc] initWithTitle:[[pinModel.photos firstObject] tagLine]
                                            subtitle:@""
                                       andCoordinate:coord
                                               place:pinModel];
    [annotations addObject:annotation];
  }
  return annotations;
}

- (MKAnnotationView *)clusterPinAnnotationViewWithAnnotation:(KPAnnotation *)annotation
                                                     mapView:(MKMapView *)mapView {
  MKAnnotationView *annotationView =
      (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
  if (annotationView == nil) {
    annotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
    UIImage *groupPinImage = [UIImage imageNamed:@"group_pin"];
    if (groupPinImage == nil) {
      NSLog(@"%@",
            [NSError errorWithDomain:@"APPSMapDelegate"
                                code:0
                            userInfo:@{
                              NSLocalizedFailureReasonErrorKey : @"Group pin image not loaded"
                            }]);
    }
    annotationView.image = groupPinImage;
  }

  annotation.title =
      [NSString stringWithFormat:@"%lu pins", (unsigned long)annotation.annotations.count];
  return annotationView;
}

- (MKAnnotationView *)pinAnnotationViewWithAnnotation:(KPAnnotation *)annotation
                                              mapView:(MKMapView *)mapView {
  MKAnnotationView *annotationView =
      (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];

  if (annotationView == nil) {
    annotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    [self configurePinAnnotationView:annotationView];
  }
  annotationView.image =
      [[[APPSUtilityFactory sharedInstance] imageUtility] imageNamed:[self pinImageName]];

  NSUInteger photosCount =
      [[[(APPSMapViewAnnotation *)[annotation.annotations anyObject] place] photos] count];
  NSString *titleFormat = nil;
  if (photosCount > 1) {
    titleFormat = kPinPhotosTitle;
  } else {
    titleFormat = kPinPhotoTitle;
  }
  annotation.title =
      [NSString stringWithFormat:NSLocalizedString(titleFormat, nil), (unsigned long)photosCount];
  annotation.subtitle = @"";
  return annotationView;
}

- (MKAnnotationView *)userLocationAnnotationViewWithAnnotation:
                          (APPSUserLocationAnnotation *)annotation
                                                       mapView:(MKMapView *)mapView {
  MKAnnotationView *annotationView =
      (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"user-location"];

  if (annotationView == nil) {
    annotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"user-location"];
    UIImage *userPinImage = [UIImage imageNamed:@"killroy_pin"];
    if (userPinImage == nil) {
      NSLog(@"%@", [NSError errorWithDomain:@"APPSMapDelegate"
                                       code:3
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"User pin image not loaded"
                                   }]);
    }
    annotationView.image = userPinImage;
  }
  return annotationView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKAnnotationView *annotationView = nil;

  if ([annotation isKindOfClass:[KPAnnotation class]]) {
    KPAnnotation *kingpinAnnotation = (KPAnnotation *)annotation;

    if ([kingpinAnnotation isCluster]) {
      annotationView =
          [self clusterPinAnnotationViewWithAnnotation:kingpinAnnotation mapView:mapView];
      annotationView.canShowCallout = YES;
    } else {
      annotationView = [self pinAnnotationViewWithAnnotation:kingpinAnnotation mapView:mapView];
    }

  } else if ([annotation isKindOfClass:[APPSUserLocationAnnotation class]]) {
    annotationView =
        [self userLocationAnnotationViewWithAnnotation:(APPSUserLocationAnnotation *)annotation
                                               mapView:mapView];
    annotationView.canShowCallout = YES;
  }

  return annotationView;
}

- (NSString *)pinImageName {
  NSString *pinImageName;
  if ([self.currentFilter isEqualToString:allFilter]) {
    pinImageName = @"map_pin";
  } else if ([self.currentFilter isEqualToString:mineFilter]) {
    pinImageName = @"my_photo_pin";
  } else if ([self.currentFilter isEqualToString:followingFilter]) {
    pinImageName = @"friends_photo_pin";
  } else if ([self.currentFilter isEqualToString:mostLikedFilter]) {
    pinImageName = @"most_popular_pin";
  } else if ([self.currentFilter isEqualToString:mostViewedFilter]) {
    pinImageName = @"most_viewed_pin";
  }
  return pinImageName;
}

- (void)annotationViewTapped:(UIButton *)control {
  MKAnnotationView *view = (MKAnnotationView *)control.superview;
  APPSMapViewAnnotation *pin = [((KPAnnotation *)view.annotation).annotations anyObject];
  [self showPhotosForPin:pin];
}

- (void)configurePinAnnotationView:(MKAnnotationView *)annotationView {
  UIButton *annotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
  annotationButton.frame = annotationView.frame;
  annotationButton.autoresizingMask =
      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [annotationButton addTarget:self
                       action:@selector(annotationViewTapped:)
             forControlEvents:UIControlEventTouchUpInside];
  [annotationView addSubview:annotationButton];
}

- (void)showPhotosForPin:(APPSMapViewAnnotation *)pin {
  self.selectedPin = pin.place;
  if (self.userLocation == nil || self.selectedPin.photos.count == 0) {
    return;
  }
  [self.parentController performSegueWithIdentifier:kPinPhotosSegue sender:self];
  self.selectedPin = nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  return [[[APPSUtilityFactory sharedInstance] mapBlurUtility] mapView:mapView
                                                    rendererForOverlay:overlay
                                                 withClearCircleRadius:kRadius];
}

#pragma mark - <KPClusteringControllerDelegate>

- (void)clusteringController:(KPClusteringController *)clusteringController
    configureAnnotationForDisplay:(KPAnnotation *)annotation {
}

- (BOOL)clusteringControllerShouldClusterAnnotations:
            (KPClusteringController *)clusteringController {
  return YES;
}

- (void)clusteringControllerWillUpdateVisibleAnnotations:
            (KPClusteringController *)clusteringController {
}

@end
