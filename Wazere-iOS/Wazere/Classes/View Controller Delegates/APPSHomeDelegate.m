//
//  APPSHomeDelegate.m
//  Wazere
//
//  Created by iOS Developer on 10/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHomeDelegate.h"
#import "APPSRACBaseRequest.h"
#import "APPSSegmentSuplementaryView.h"
#import "APPSProfileViewController.h"

#import "APPSHomeRectCollectionViewLayout.h"
#import "APPSHomeSquareCollectionViewLayout.h"
#import "APPSHomeCollectionViewLayout.h"

#import "APPSStrategyTableViewController.h"
#import "APPSFiltersViewControllerDelegate.h"
#import "APPSFiltersViewControllerConfigurator.h"

@interface APPSHomeDelegate () <APPSSegmentSuplementaryViewDelegate>

@end

@implementation APPSHomeDelegate
@synthesize user = _user;

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user {
  self = [super initWithViewController:viewController user:user];
  if (self) {
    _filter = [[[self suplementaryViewButtonItems] firstObject] lowercaseString];
    _user = user;
  }
  return self;
}

- (NSString *)screenName {
    return @"Home screen";
}

#pragma mark - initCollectionViewLayouts

- (void)initCollectionViewLayouts {
  self.rectCollectionViewLayout = [[APPSHomeRectCollectionViewLayout alloc] init];
  self.rectCollectionViewLayout.delegate = self;
  self.squareCollectionViewLayout = [[APPSHomeSquareCollectionViewLayout alloc] init];
  self.baseLayout = [[APPSHomeCollectionViewLayout alloc] init];
}

- (NSMutableDictionary *)addOtherParamsAtParams:(NSMutableDictionary *)params {
  return params;
}

- (APPSRACBaseRequest *)photoRequestWithParams:(NSDictionary *)params {
  NSString *keyPath = [NSString
      stringWithFormat:KeyPathHomePhotos,
                       [[[APPSCurrentUserManager sharedInstance] currentUser] userId],
                       [self.filter stringByReplacingOccurrencesOfString:@" " withString:@"_"]];

  // MAKE PHOTO REQUEST
  APPSRACBaseRequest *photoRequest = [[APPSRACBaseRequest alloc] initWithObject:nil
                                                                         params:params
                                                                         method:HTTPMethodGET
                                                                        keyPath:keyPath
                                                                     disposable:nil];
  return photoRequest;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  APPSSegmentSuplementaryView *view =
      (APPSSegmentSuplementaryView *)[super collectionView:collectionView
                         viewForSupplementaryElementOfKind:kind
                                               atIndexPath:indexPath];
  return view;
}

- (BOOL)openProfileForPhoto:(APPSPhotoModel *)photo {
  return YES;
}

#pragma mark - Empty Sreen Methods

- (BOOL)shouldHighlightTabbarCameraButton {
  return YES;
}

- (BOOL)shouldShowEmptyScreen {
    return self.photoModelsStatusType == PhotoModelsStatusTypeEmpty;
}

- (NSString *)emptyMessage {
    return NSLocalizedString(@"Tap on the camera to share your first photo", nil);
}

- (NSString *)emptyTitle {
    return NSLocalizedString(@"See the photos being shared near you!", nil);
}

- (BOOL)shouldShowEmptyTopImage {
    return YES;
}

- (BOOL)shouldShowBottomImage {
    return YES;
}

#pragma mark - APPSSegmentSuplementaryViewDelegate

- (NSArray *)suplementaryViewButtonItems {
  return @[ @"New", @"Popular", @"Following"];
}

- (void)suplementaryView:(APPSSegmentSuplementaryView *)view
            valueChanged:(UISegmentedControl *)sender {
    self.filter = [[self suplementaryViewButtonItems][sender.selectedSegmentIndex] lowercaseString];
    self.photoModelsStatusType = PhotoModelsStatusTypeIndefinitely;
    [self.parentController reloadCollectionView];
}

#pragma mark - Actions 

- (void)changeLayoutButtonPressed:(UIBarButtonItem *)sender {
    BOOL isViewModeSquare = self.viewMode == CollectionViewModeSquare;
    NSString *buttonImage = isViewModeSquare ? @"new_grid" : @"list_view";
    [sender setImage:[UIImage imageNamed:buttonImage]];
    isViewModeSquare ? [self collectionReusableView:nil listAction:nil]
    : [self collectionReusableView:nil gridAction:nil];
}

@end
