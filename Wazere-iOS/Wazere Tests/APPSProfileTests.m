//
//  APPSProfileTests.m
//  Wazere
//
//  Created by Petr Yanenko on 12/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "APPSProfileViewController.h"
#import "APPSTabBarViewController.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSPhotoMultipartRequest.h"
#import "APPSSharePhotoModel.h"

@interface APPSProfileTests : XCTestCase

@property(weak, NS_NONATOMIC_IOSONLY) APPSProfileViewController *profileController;
@property(weak, NS_NONATOMIC_IOSONLY) APPSProfileViewControllerDelegate *delegate;

@end

@implementation APPSProfileTests

static NSInteger const kMaxDeleteInterval = 5;
static NSInteger const kMaxReloadInterval = 100;

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the
  // class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the
  // class.
  self.profileController = nil;
  [super tearDown];
}

- (void)sharePhoto {
  CGFloat sharePhotoIntervalMultiplier = 1.5;
  NSTimeInterval shareInterval =
      arc4random_uniform(kMaxDeleteInterval * sharePhotoIntervalMultiplier);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(shareInterval * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
      APPSSharePhotoModel *photoModel = [[APPSSharePhotoModel alloc] init];
      UIImage *image = [UIImage imageNamed:@"50"];
      photoModel.images = @[ image ];
      photoModel.location = [[[APPSUtilityFactory sharedInstance] locationUtility] currentLocation];
      NSString *keyPath =
          [NSString stringWithFormat:KeyPathUserPhotos,
                                     [[APPSCurrentUserManager sharedInstance] currentUser].userId];
      APPSPhotoMultipartRequest *command =
          [[APPSPhotoMultipartRequest alloc] initWithObject:photoModel
                                                     params:nil
                                                     method:HTTPMethodPOST
                                                    keyPath:keyPath
                                                  imageName:@"photo[photo]"
                                                 disposable:nil];
      @weakify(self);
      [command.execute subscribeCompleted:^{
          @strongify(self);
          [[NSNotificationCenter defaultCenter]
              postNotificationName:kReloadProfileNotificationName
                            object:self
                          userInfo:@{kReloadProfileNotificationKey : photoModel}];
          [self sharePhoto];
      }];
  });
}

- (void)deletePhoto {
  NSTimeInterval deleteInterval = arc4random_uniform(kMaxDeleteInterval);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deleteInterval * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
      NSArray *photoModels = self.delegate.photoModels;
      UIActionSheet *moreOptionsAtionSheet;
      if (photoModels.count) {
        unsigned int itemIndex = arc4random_uniform((unsigned int)photoModels.count - 1);
        self.delegate.selectedPhoto = photoModels[itemIndex];
        moreOptionsAtionSheet = [self.delegate moreOptionsActionSheet];
        [moreOptionsAtionSheet showInView:self.profileController.collectionView];
      }
      unsigned int maxDeleteTapTimeout = 3;
      NSTimeInterval deleteTapTimeout = arc4random_uniform(maxDeleteTapTimeout);
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deleteTapTimeout * NSEC_PER_SEC)),
                     dispatch_get_main_queue(), ^{
          NSInteger kFirstButtonIndex = 0;
          [moreOptionsAtionSheet dismissWithClickedButtonIndex:kFirstButtonIndex animated:YES];
          [self deletePhoto];
      });
  });
}

- (void)scrollToLastRow {
  CGFloat paginationDevider = 10.0;
  NSTimeInterval scrollInterval = arc4random_uniform(kMaxReloadInterval) / paginationDevider;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(scrollInterval * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
      NSArray *photoModels = self.delegate.photoModels;
      if (photoModels.count) {
        [self.profileController.collectionView
            scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:photoModels.count - 1 inSection:0]
                   atScrollPosition:UICollectionViewScrollPositionBottom
                           animated:YES];
        [self.delegate loadPhotos];
      }
      [self scrollToLastRow];
  });
}

- (void)refreshData {
  NSTimeInterval refreshInterval = arc4random_uniform(kMaxReloadInterval);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(refreshInterval * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
      [self.profileController.refreshControl beginRefreshing];
      [self.profileController refresh:self.profileController.refreshControl];
      [self refreshData];
  });
}

- (void)finishTest {
  XCTestExpectation *testExpectation =
      [self expectationWithDescription:@"Wait until test finishes"];
  NSTimeInterval testInterval = 60 * 30;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((testInterval - 1) * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{ [testExpectation fulfill]; });
  [self waitForExpectationsWithTimeout:testInterval
                               handler:^(NSError *error) { XCTAssertNil(error, @"%@", error); }];
  XCTAssert(YES);
}

- (void)testProfile {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for tabBar"];
  NSTimeInterval waitForInterval = 10.0, timout = waitForInterval + 1;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitForInterval * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
      UIViewController *rootViewController = [APPSTabBarViewController rootViewController];
      if ([rootViewController isKindOfClass:[APPSTabBarViewController class]]) {
        APPSTabBarViewController *tabBar = (APPSTabBarViewController *)rootViewController;
        if (tabBar.viewControllers.count > profileIndex) {
          [tabBar setSelectedViewController:tabBar.viewControllers[profileIndex]];
          self.profileController = (APPSProfileViewController *)
              [[(UINavigationController *)
                      tabBar.selectedViewController viewControllers] firstObject];
          self.delegate = (APPSProfileViewControllerDelegate *)self.profileController.delegate;
          self.delegate.selectedTab = APPSProfileSelectedTabTypeList;
          [self.delegate changeCollectionViewLayoutWithViewMode:CollectionViewModeRect];
          [self.profileController.collectionView setContentOffset:CGPointZero];
          [expectation fulfill];
        } else {
          XCTAssert(NO);
        }
      } else {
        XCTAssert(NO);
      }
  });
  [self waitForExpectationsWithTimeout:timout
                               handler:^(NSError *error) { XCTAssertNil(error, @"%@", error); }];
  [self refreshData];
  [self scrollToLastRow];
  [self deletePhoto];
  [self sharePhoto];
  [self finishTest];
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{// Put the code you want to measure the time of here.
  }];
}

@end
