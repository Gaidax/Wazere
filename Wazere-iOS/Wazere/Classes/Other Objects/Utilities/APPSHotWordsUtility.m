//
//  APPSHotWordsUtility.m
//  Wazere
//
//  Created by iOS Developer on 11/13/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSHotWordsUtility.h"
#import "APPSProfileCommand.h"
#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileSegueState.h"
#import "APPSHashtagPhotoConfigurator.h"
#import "APPSHashtagPhotoDelegate.h"

@implementation APPSHotWordsUtility

- (void)detectedTweetHotWord:(STTweetHotWord)hotWord
                    withText:(NSString *)text
        navigationController:(UINavigationController *)navController {
  switch (hotWord) {
    case STTweetHandle:
      [self openUserProfileForMention:text withNanigationController:navController];
      break;
    case STTweetHashtag:
      [self openHashtagPhotosForHashtag:text withNanigationController:navController];
      break;
    default:
      break;
  }
}

- (void)detectedHotWord:(HotWordType)hotWord
                withText:(NSString *)text
    navigationController:(UINavigationController *)navController {
  switch (hotWord) {
    case HotWordTypeMention:
      [self openUserProfileForMention:text withNanigationController:navController];
      break;
    case HotWordTypeHashtag:
      [self openHashtagPhotosForHashtag:text withNanigationController:navController];
      break;
    default:
      break;
  }
}

- (void)openUserProfileForMention:(NSString *)mention
         withNanigationController:(UINavigationController *)navController {
  APPSProfileCommand *profileCommand = [[APPSProfileCommand alloc]
      initWithObject:nil
              method:HTTPMethodGET
             keyPath:[NSString stringWithFormat:kFindUserKeyPath,
                                                [mention substringFromIndex:@"@".length]]
          disposable:nil];
  APPSSpinnerView *spinner = [[APPSSpinnerView alloc] init];
  [spinner startAnimating];
  @weakify(self);
  @weakify(navController);
  [[profileCommand execute] subscribeNext:^(id<APPSUserProtocol> user) {
      @strongify(self);
      @strongify(navController);
      if (user) {
        [self openProfileWithUser:user navigationController:navController];
      }
      [spinner stopAnimating];
  } error:^(NSError *error) {
      [spinner stopAnimating];
      NSLog(@"%@", error);
  }];
}

- (void)openHashtagPhotosForHashtag:(NSString *)hashtag
           withNanigationController:(UINavigationController *)navController {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
  APPSProfileViewController *profile =
      [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  profile.configurator = [[APPSHashtagPhotoConfigurator alloc] initWithHashtag:hashtag];
  APPSProfileViewControllerDelegate *delegate = [[APPSHashtagPhotoDelegate alloc]
      initWithViewController:profile
                        user:[[APPSCurrentUserManager sharedInstance] currentUser]
                     hashtag:hashtag];
  profile.delegate = delegate;
  profile.dataSource = delegate;
  [navController pushViewController:profile animated:YES];
}

- (void)openProfileWithUser:(id<APPSUserProtocol>)user
       navigationController:(UINavigationController *)navController {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
  APPSProfileViewController *profile =
      [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  profile.configurator = [[APPSProfileViewControllerConfigurator alloc] init];
  APPSProfileViewControllerDelegate *delegate =
      [[APPSProfileViewControllerDelegate alloc] initWithViewController:profile user:user];
  profile.delegate = delegate;
  profile.dataSource = delegate;
  profile.state = [[APPSProfileSegueState alloc] init];
  [navController pushViewController:profile animated:YES];
}

@end
