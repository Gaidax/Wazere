//
//  APPSMapViewController.m
//  Wazere
//
//  Created by iOS Developer on 9/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapViewController.h"
#import "APPSMapConfigurator.h"

@interface APPSMapViewController ()

@property(strong, nonatomic) NSArray *annotations;
@property(strong, nonatomic) NSArray *overlays;
@property(assign, nonatomic) CGRect mapFrame;
@property(assign, nonatomic) MKCoordinateRegion mapRegion;

@end

@implementation APPSMapViewController

- (void)dealloc {
  _mapView.delegate = nil;
  self.searchDisplayController.delegate = nil;
  self.searchDisplayController.searchResultsDataSource = nil;
  self.searchDisplayController.searchResultsDelegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleWillResignActiveNotification:)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleDidBecomeActiveNotification:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

- (void)handleWillResignActiveNotification:(NSNotification *)notification {
  if ([self.delegate respondsToSelector:@selector(mapViewControllerWillDisappear:)]) {
    [self.delegate mapViewControllerWillDisappear:self];
  }
}

- (void)handleDidBecomeActiveNotification:(NSNotification *)notification {
  if ([self.delegate respondsToSelector:@selector(mapViewControllerWillAppear:)]) {
    [self.delegate mapViewControllerWillAppear:self];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self recreateMapView];
  if ([self.delegate respondsToSelector:@selector(mapViewControllerWillAppear:)]) {
    [self.delegate mapViewControllerWillAppear:self];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([self.delegate respondsToSelector:@selector(mapViewControllerWillDisappear:)]) {
    [self.delegate mapViewControllerWillDisappear:self];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self removeMapView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)disposeViewControllerNotification:(NSNotification *)notification {
  [self removeMapView];
  [self recreateMapView];
}

- (void)removeMapView {
  if (self.mapView) {
    self.clusteringController = nil;
    self.mapFrame = self.mapView.frame;
    self.mapRegion = self.mapView.region;
    self.annotations = self.mapView.annotations;
    self.overlays = self.mapView.overlays;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
  }
}

- (void)recreateMapView {
  if (self.mapView == nil) {
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.mapFrame];
    map.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    map.delegate = self;
    self.mapView = map;
    [self.view addSubview:map];
    [self.view sendSubviewToBack:map];
    [self.configurator configureViewController:self];
    if (self.clusteringController == nil) {
      [self.mapView addAnnotations:self.annotations];
    }
    [self.mapView addOverlays:self.overlays];
    [self.mapView setRegion:self.mapRegion];
    self.annotations = nil;
    self.overlays = nil;
  }
}

- (void)goToRegion:(MKCoordinateRegion)region {
  [self.mapView setRegion:region animated:YES];
}

- (void)addAnnotationWithPlacemark:(CLPlacemark *)placemark {
  if ([self.delegate respondsToSelector:@selector(mapViewController:addAnnotationWithPlacemark:)]) {
    [self.delegate mapViewController:self addAnnotationWithPlacemark:placemark];
  }
}

#pragma mark - <APPSMapFiltersDelegate>

- (void)mapFiltersView:(APPSMapFiltersView *)filtersView
          selectFilter:(NSString *)filter
            dateFilter:(NSString *)dateFilter {
  if ([self.delegate respondsToSelector:
                         @selector(mapViewController:mapFiltersView:selectFilter:dateFilter:)]) {
    [self.delegate mapViewController:self
                      mapFiltersView:filtersView
                        selectFilter:filter
                          dateFilter:dateFilter];
  }
}

#pragma mark - <MKMapViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([self.delegate respondsToSelector:@selector(mapView:viewForAnnotation:)]) {
    return [self.delegate mapView:mapView viewForAnnotation:annotation];
  } else {
    return nil;
  }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
  if ([self.delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)]) {
    [self.delegate mapViewDidFinishLoadingMap:mapView];
  }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  if ([self.delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)]) {
    [self.delegate mapView:mapView regionDidChangeAnimated:animated];
  }
}

- (void)mapView:(MKMapView *)mapView
        annotationView:(MKAnnotationView *)view
    didChangeDragState:(MKAnnotationViewDragState)newState
          fromOldState:(MKAnnotationViewDragState)oldState {
  if ([self.delegate
          respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)]) {
    [self.delegate mapView:mapView
            annotationView:view
        didChangeDragState:newState
              fromOldState:oldState];
  }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
  if ([self.delegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)]) {
    [self.delegate mapViewWillStartLocatingUser:mapView];
  }
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
  if ([self.delegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)]) {
    [self.delegate mapViewDidStopLocatingUser:mapView];
  }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  if ([self.delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)]) {
    [self.delegate mapView:mapView didUpdateUserLocation:userLocation];
  }
}

- (void)mapView:(MKMapView *)mapView
                   annotationView:(MKAnnotationView *)view
    calloutAccessoryControlTapped:(UIControl *)control {
  if ([self.delegate
          respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
    [self.delegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
  }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  if ([self.delegate respondsToSelector:@selector(mapView:rendererForOverlay:)]) {
    return [self.delegate mapView:mapView rendererForOverlay:overlay];
  }
  return nil;
}

#pragma mark - <KPClusteringControllerDelegate>

- (void)clusteringController:(KPClusteringController *)clusteringController
    configureAnnotationForDisplay:(KPAnnotation *)annotation {
  if ([self.delegate
          respondsToSelector:@selector(clusteringController:configureAnnotationForDisplay:)]) {
    [self.delegate clusteringController:clusteringController
          configureAnnotationForDisplay:annotation];
  }
}

- (BOOL)clusteringControllerShouldClusterAnnotations:
            (KPClusteringController *)clusteringController {
  if ([self.delegate respondsToSelector:@selector(clusteringControllerShouldClusterAnnotations:)]) {
    return [self.delegate clusteringControllerShouldClusterAnnotations:clusteringController];
  } else {
    return NO;
  }
}

- (void)clusteringControllerWillUpdateVisibleAnnotations:
            (KPClusteringController *)clusteringController {
  if ([self.delegate
          respondsToSelector:@selector(clusteringControllerWillUpdateVisibleAnnotations:)]) {
    [self.delegate clusteringControllerWillUpdateVisibleAnnotations:clusteringController];
  }
}

#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
    shouldReloadTableForSearchString:(NSString *)searchString {
  if ([self.searchDelegate respondsToSelector:@selector(searchDisplayController:
                                                  shouldReloadTableForSearchString:)]) {
    return [self.searchDelegate searchDisplayController:controller
                       shouldReloadTableForSearchString:searchString];
  } else {
    return YES;
  }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
  if ([self.searchDelegate respondsToSelector:@selector(searchDisplayControllerWillBeginSearch:)]) {
    [self.searchDelegate searchDisplayControllerWillBeginSearch:controller];
  }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
  if ([self.searchDelegate respondsToSelector:@selector(searchDisplayControllerWillEndSearch:)]) {
    [self.searchDelegate searchDisplayControllerWillEndSearch:controller];
  }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.searchDelegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.searchDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark UITableViewDeleate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.searchDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.searchDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

#pragma mark - APPSViewController Subclassing

- (void)keyboardWillShows:(NSNotification *)notification {
}

- (void)keyboardWillHides:(NSNotification *)notification {
}

@end
