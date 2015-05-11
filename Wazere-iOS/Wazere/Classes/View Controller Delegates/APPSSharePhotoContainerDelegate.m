//
//  APPSSharePhotoContainerDelegate.m
//  Wazere
//
//  Created by Petr Yanenko on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoContainerDelegate.h"

#import "APPSTopBarContainerViewController.h"
#import "APPSTabBarViewController.h"

#import "APPSSharePhotoModel.h"
#import "APPSPhotoMultipartREquest.h"
#import "APPSPhotoModel.h"
#import "APPSCameraConstants.h"
#import "APPSPhotoImageView.h"

@interface APPSSharePhotoContainerDelegate ()

@property(strong, nonatomic) RACSignal *saveSignal;
@property(strong, nonatomic) APPSMultipartModel *shareModel;
@property(strong, nonatomic) RACSignal *commandSignal;

@property(strong, nonatomic) UIImage *blurredImageToShare;
@end

@implementation APPSSharePhotoContainerDelegate

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Share photo";
}

- (void)setSaveSignal:(RACSignal *)saveSignal {
  if (saveSignal != _saveSignal) {
    _saveSignal = saveSignal;
    @weakify(self);
    [_saveSignal subscribeNext:^(APPSMultipartModel *shareModel) {
        @strongify(self);
        if (shareModel) {
//          self.parentController.rightBarButton.enabled = YES;
//          self.parentController.rightBarButton.hidden = NO;
          self.shareModel = shareModel;
         } else {
//          self.parentController.rightBarButton.enabled = NO;
//          self.parentController.rightBarButton.hidden = YES;
          self.shareModel = nil;
        }
    }];
  }
}

- (void)disposeViewController:(UIViewController *)viewController {
  [self.processingDelegate setShowPicker:YES];
}

- (void)topBarContainerViewController:(APPSTopBarContainerViewController *)viewController
                     tapsCenterButton:(UIButton *)sender {
  [self.parentController.view endEditing:YES];
}

- (void)topBarContainerViewController:(APPSTopBarContainerViewController *)viewController
                       tapsLeftButton:(UIButton *)sender {
  [self.processingDelegate didFinishProcessingImageWithSegue:kCameraFilterSegue];
}

- (void)topBarContainerViewController:(APPSTopBarContainerViewController *)viewController
                      tapsRightButton:(UIButton *)sender {
  APPSSharePhotoModel *photoModel = (APPSSharePhotoModel *)self.shareModel;
  if (photoModel.isPublic == NO && photoModel.friendIds.count == 0) {
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:nil
                  message:NSLocalizedString(@"Don't forget to choose a friend!", nil)
                 delegate:nil
        cancelButtonTitle:NSLocalizedString(@"Ok", nil)
        otherButtonTitles:nil];
    [alert show];
    return;
  }
  NSString *keyPath =
      [NSString stringWithFormat:KeyPathUserPhotos,
                                 [[APPSCurrentUserManager sharedInstance] currentUser].userId];
  APPSPhotoMultipartRequest *command =
      [[APPSPhotoMultipartRequest alloc] initWithObject:self.shareModel
                                                 params:nil
                                                 method:HTTPMethodPOST
                                                keyPath:keyPath
                                              imageName:@"photo[photo]"
                                             disposable:nil];
  self.commandSignal = [command execute];

  self.parentController.rightBarButton.enabled = NO;

  APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:viewController.view];
  [spinner startAnimating];
  [self.parentController.view endEditing:YES];
  [self sharePhotoWithSpinner:spinner];
}

- (void)sharePhotoToSocialNetworksIfNeeded:(APPSPhotoModel *)model {
  [[SDImageCache sharedImageCache] storeImage:self.savedImage forKey:[model.URL absoluteString]];

  APPSSharePhotoModel *sharePhotoModel = (APPSSharePhotoModel *)self.shareModel;
  model.blurredImage = self.blurredImageToShare;
  if (sharePhotoModel.shareToFacebook) {
    [[[APPSUtilityFactory sharedInstance] facebookUtility] sharePhoto:model completion:NULL];
  }
  if (sharePhotoModel.shareToTwitter) {
    [[[APPSUtilityFactory sharedInstance] twitterUtility] authorizeAndPublishPhoto:model
                                                                        completion:NULL];
  }
}

- (void)sharePhotoWithSpinner:(APPSSpinnerView *)spinner {
  @weakify(self);
  @weakify(spinner);
  [self.commandSignal subscribeNext:^(APPSPhotoModel *model) {
      @strongify(self);
      @strongify(spinner);
      if (model == nil) {
        NSLog(@"%@", [NSError errorWithDomain:@"APPSSharePhotoContainerDelegate"
                                         code:0
                                     userInfo:@{
                                       NSLocalizedFailureReasonErrorKey : @"Response photo is nil"
                                     }]);
      } else {
        self.blurredImageToShare = [[[APPSUtilityFactory sharedInstance] imageUtility]
            createBlurredPhotoWithTagline:((APPSSharePhotoModel *)self.shareModel).tagline
                                    image:[self.shareModel.images firstObject]
                                    error:nil];
        [self sharePhotoToSocialNetworksIfNeeded:model];
        [self.processingDelegate setShowPicker:YES];
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kReloadProfileNotificationName
                          object:self
                        userInfo:@{kReloadProfileNotificationKey : self.shareModel}];
        [[APPSTabBarViewController rootViewController] dismissViewControllerAnimated:YES
                                                                          completion:NULL];
        [[APPSTabBarViewController rootViewController]
            setSelectedViewController:
                [[APPSTabBarViewController rootViewController] viewControllers][profileIndex]];
      }
      self.parentController.rightBarButton.enabled = YES;
      [spinner stopAnimating];
  } error:^(NSError *error) {
      @strongify(self);
      @strongify(spinner);
      [spinner stopAnimating];
      self.parentController.rightBarButton.enabled = YES;
      NSLog(@"%@", error);
  }];
}

@end
