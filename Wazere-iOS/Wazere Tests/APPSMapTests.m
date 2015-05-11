//
//  APPSMapTests.m
//  Wazere
//
//  Created by Petr Yanenko on 9/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "APPSMapDelegate.h"
#import <MapKit/MapKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "APPSPinModel.h"
#import "APPSPhotosModel.h"
#import "APPSRACBaseRequest.h"

@interface APPSMapDelegate ()

@property(strong, NS_NONATOMIC_IOSONLY) APPSRACBaseRequest *pinRequest;
@property(strong, NS_NONATOMIC_IOSONLY) NSArray *places;
@property(strong, NS_NONATOMIC_IOSONLY) APPSPhotosModel *photosModel;
@property(strong, NS_NONATOMIC_IOSONLY) NSArray *selectedAnnotations;
@property(strong, NS_NONATOMIC_IOSONLY) NSString *currentFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSString *currentDateFilter;

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

@interface APPSMapTests : XCTestCase

@property(strong, nonatomic) NSTimer *timer;
@property(assign, nonatomic) NSInteger count;
@property(strong, nonatomic) APPSMapDelegate *delegate;
@property(strong, nonatomic) XCTestExpectation *expectation;

@end

@implementation APPSMapTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
  self.delegate = [[APPSMapDelegate alloc] init];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  self.delegate = nil;
  [super tearDown];
}

#pragma mark tests

- (void)testCalculateMapVisibleRadius {
  CLLocationDistance radius = 0, distance = 500;
  CLLocationDegrees latitude, longitude;

  for (NSInteger i = 0; radius < 1000000; i++) {
    MKCoordinateRegion simpleRegion = MKCoordinateRegionMakeWithDistance(
        CLLocationCoordinate2DMake(30.43587, 40.34579), distance, distance);
    [self.delegate calculateOutRadius:&radius
                          outLatitude:&latitude
                         outLongitude:&longitude
                           withRegion:simpleRegion];
    XCTAssertEqual(latitude, simpleRegion.center.latitude, @"Latitude not equal");
    XCTAssertEqual(longitude, simpleRegion.center.longitude, @"Longitude not equal");
    XCTAssertEqualWithAccuracy(radius, distance / 2.0, radius * 0.005, @"Invalid radius");
    distance += 500;
  }
}

#pragma mark performance tests

- (void)fetchAnnotationsWithRadius:(CLLocationDistance)radius
                          latitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)longitude
                        onDelegate:(APPSMapDelegate *)delegate {
  [delegate loadPlacesWithLatitude:latitude
                         longitude:longitude
                            radius:radius
                            filter:@"all"
                        dateFilter:@"last_month"
                              page:1];
}

- (void)testAnnotations {
  __block CLLocationDistance radius = 200000;
  __block MKCoordinateRegion simpleRegion = MKCoordinateRegionMakeWithDistance(
      CLLocationCoordinate2DMake(36.23642586171627, 50.004856712588015), radius, radius);
  XCTestExpectation *loadPinExpectation = [self expectationWithDescription:@"load pins"];
  @weakify(self);
  [RACObserve(self, delegate.places) subscribeNext:^(NSArray *places) {
      @strongify(self);
      if (places) {
        for (APPSPinModel *pin in places) {
          XCTAssertLessThan(pin.latitude, simpleRegion.center.latitude +
                                              simpleRegion.span.latitudeDelta * 0.5 * (1 + 0.01));
          XCTAssertGreaterThan(
              pin.latitude,
              simpleRegion.center.latitude - simpleRegion.span.latitudeDelta * 0.5 * (1 + 0.01));
          XCTAssertLessThan(pin.longitude, simpleRegion.center.longitude +
                                               simpleRegion.span.longitudeDelta * 0.5 * (1 + 0.01));
          XCTAssertGreaterThan(
              pin.longitude,
              simpleRegion.center.longitude - simpleRegion.span.longitudeDelta * 0.5 * (1 + 0.01));
        }
        if (self.delegate.photosModel.currentPage >= self.delegate.photosModel.totalPages) {
          if (radius > 0) {
            radius -= 1000.0;
            simpleRegion = MKCoordinateRegionMakeWithDistance(
                CLLocationCoordinate2DMake(36.23642586171627, 50.004856712588015), radius, radius);
            [self fetchAnnotationsWithRadius:radius * 0.5
                                    latitude:simpleRegion.center.latitude
                                   longitude:simpleRegion.center.longitude
                                  onDelegate:self.delegate];
          } else {
            [loadPinExpectation fulfill];
          }
        }
      }
  }];
  [self fetchAnnotationsWithRadius:radius * 0.5
                          latitude:simpleRegion.center.latitude
                         longitude:simpleRegion.center.longitude
                        onDelegate:self.delegate];
  [self waitForExpectationsWithTimeout:60 * 60
                               handler:^(NSError *error) { XCTAssertNil(error, @"%@", error); }];
}

- (void)fire:(NSTimer *)timer {
  printf("\ncount -> %ld\n\n", (long)self->_count);
  if (self.count < 750) {
    CLLocationDistance radius = arc4random_uniform(4000000000) / 10000.0;
    //        CLLocationDegrees latitude = 90 - arc4random_uniform(180000) /
    //        1000.0;
    //        CLLocationDegrees longitude = 180 - arc4random_uniform(360000) /
    //        1000.0;
    CLLocationDegrees latitude = 36.23642586171627;
    CLLocationDegrees longitude = 50.004856712588015;
    MKCoordinateRegion simpleRegion = MKCoordinateRegionMakeWithDistance(
        CLLocationCoordinate2DMake(latitude, longitude), radius, radius);
    [self fetchAnnotationsWithRadius:radius * 0.5
                            latitude:simpleRegion.center.latitude
                           longitude:simpleRegion.center.longitude
                          onDelegate:self.delegate];
    self.count++;
    NSInteger seconds = arc4random_uniform(1000) / 100.0;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                  target:self
                                                selector:@selector(fire:)
                                                userInfo:nil
                                                 repeats:NO];
  } else {
    [self.expectation fulfill];
  }
}

- (void)testAsyncAnnotations {
  self.expectation = [self expectationWithDescription:@"async load pins"];
  [self fire:self.timer];
  [self waitForExpectationsWithTimeout:60 * 60
                               handler:^(NSError *error) { XCTAssertNil(error, @"%@", error); }];
}

@end
