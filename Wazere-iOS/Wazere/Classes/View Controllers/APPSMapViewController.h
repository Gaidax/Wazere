//
//  APPSMapViewController.h
//  Wazere
//
//  Created by iOS Developer on 9/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewController.h"
#import "KPClusteringController.h"
#import "APPSMapFiltersView.h"
#import "APPSViewControllerDelegate.h"

@class APPSMapViewController;

@protocol
    APPSMapDelegate<APPSViewControllerDelegate, KPClusteringControllerDelegate, MKMapViewDelegate>

@property(weak, NS_NONATOMIC_IOSONLY) APPSMapViewController *parentController;

@optional

- (void)mapViewController:(APPSMapViewController *)controller
           mapFiltersView:(APPSMapFiltersView *)filtersView
             selectFilter:(NSString *)filter
               dateFilter:(NSString *)dateFilter;
- (void)mapViewController:(APPSMapViewController *)controller
    addAnnotationWithPlacemark:(CLPlacemark *)placemark;

- (void)mapViewControllerWillAppear:(APPSMapViewController *)controller;
- (void)mapViewControllerWillDisappear:(APPSMapViewController *)controller;

@end

@interface APPSMapViewController
    : APPSViewController<KPClusteringControllerDelegate, MKMapViewDelegate,
                         APPSMapFiltersViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate,
                         UITableViewDataSource, UITableViewDelegate>

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet MKMapView *mapView;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UISearchBar *searchBar;

@property(strong, NS_NONATOMIC_IOSONLY) KPClusteringController *clusteringController;

@property(strong, NS_NONATOMIC_IOSONLY) id<APPSMapDelegate> delegate;
@property(strong, NS_NONATOMIC_IOSONLY)
    id<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
        searchDelegate;

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet APPSMapFiltersView *filtersView;

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet NSLayoutConstraint *topMapViewConstraint;

- (void)goToRegion:(MKCoordinateRegion)region;
- (void)addAnnotationWithPlacemark:(CLPlacemark *)placemark;

@end
