//
//  APPSTabBarViewController.m
//  Wazere
//
//  Created by iOS Developer on 9/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSTabBarViewController.h"
#import "APPSNavigationViewController.h"

// Home-screen
#import "APPSHomeConfigurator.h"
#import "APPSHomeDelegate.h"
#import "APPSHomeSegueState.h"

// Camera
#import "APPSCameraConfigurator.h"
#import "APPSCameraViewController.h"
#import "APPSCameraSegueState.h"

// Map
#import "APPSMapViewController.h"
#import "APPSMapDelegate.h"
#import "APPSMapConfigurator.h"
#import "APPSMapSegueState.h"

// Profile
#import "APPSProfileSegueState.h"
#import "APPSProfileViewController.h"

// NewsFeed
#import "APPSStrategyTableViewController.h"
#import "APPSNewsFeedViewControllerConfigurator.h"
#import "APPSNewsFeedViewControllerDelegate.h"
#import "APPSNewsFeedSegueState.h"

#import "APPSTabbarBubble.h"

#define TAB_BAR_TITLES @[ @"Home", @"Nearby", @"Camera", @"News Feed", @"Profile" ]
#define TAB_BAR_IMAGES                \
  @[                                  \
    IMAGE_WITH_NAME(@"tb_home"),      \
    IMAGE_WITH_NAME(@"tb_map"),       \
    IMAGE_WITH_NAME(@"tb_camera"),    \
    IMAGE_WITH_NAME(@"tb_news_feed"), \
    IMAGE_WITH_NAME(@"tb_profile")    \
  ]
#define TAB_BAR_SELECTED_IMAGES                \
  @[                                           \
    IMAGE_WITH_NAME(@"tb_home_active"),        \
    IMAGE_WITH_NAME(@"tb_map_selected"),       \
    IMAGE_WITH_NAME(@"tb_camera_selected"),    \
    IMAGE_WITH_NAME(@"tb_news_feed_selected"), \
    IMAGE_WITH_NAME(@"tb_profile_selected")    \
  ]

@interface APPSTabBarViewController () <UITabBarControllerDelegate>

@property(assign, NS_NONATOMIC_IOSONLY) BOOL isClean;

@end

@implementation APPSTabBarViewController

static NSString *const kProfileStoryboardIdentifier = @"ProfileScreenIdentifier";
static NSString *const kMapScreenIdentifier = @"MapScreenIdentifier";
static NSString *const kNewsfeedScreenIdentifier = @"NewsfeedScreenIdentifier";
static NSString *const kCameraScreenIdentifier = @"CameraScreenIdentifier";

+ (APPSTabBarViewController *)rootViewController {
  return (APPSTabBarViewController *)[[[[[UIApplication
          sharedApplication] delegate] window] rootViewController] presentedViewController];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.previousTabIndex = NSNotFound;
  [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
  [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
  self.delegate = self;

  [self createViewControllers];
  [self configureHomeController];
  [self configureMapController];
  [self configureCameraController];

  [self configureNewsfeedController];

  [self configureTabBar];
  [self initTabbarBubbleView];

  if ([APPSUtilityFactory sharedInstance].notificationUtility.openedAppFromPush) {
    self.selectedViewController = self.viewControllers[newsFeedIndex];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationDidBecomeActive:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];

  [self customizeProfileViewController];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  APPSNotificationUtility *utility = [APPSUtilityFactory sharedInstance].notificationUtility;
  if (utility.lastNotification) {
    [utility showBubbeView];
  }
}

- (void)setPreviousTabIndex:(NSUInteger)previousTabIndex {
  if (previousTabIndex != mapIndex) {
    _previousTabIndex = previousTabIndex;
  }
}

- (void)configureTabBar {
  for (NSUInteger i = 0; i < self.tabBar.items.count; i++) {
    [self customizeTabBarItem:self.tabBar.items[i]
                        title:TAB_BAR_TITLES[i]
                        image:TAB_BAR_IMAGES[i]
                selectedImage:TAB_BAR_SELECTED_IMAGES[i]];
  }
}

- (void)configureHomeController {
  APPSProfileViewController *homeController =
      (APPSProfileViewController *)((UINavigationController *)self.viewControllers[homeIndex])
          .viewControllers[0];
  [self configureHomeViewController:homeController];
}

- (void)configureHomeViewController:(APPSProfileViewController *)homeController {
  homeController.configurator = [[APPSHomeConfigurator alloc] init];
  APPSHomeDelegate *homeDelegate = [[APPSHomeDelegate alloc]
      initWithViewController:homeController
                        user:[[APPSCurrentUserManager sharedInstance] currentUser]];
  homeController.delegate = homeDelegate;
  homeController.dataSource = homeDelegate;
  homeController.state = [[APPSHomeSegueState alloc] init];
}

- (void)configureMapController {
  APPSMapViewController *mapController =
      (APPSMapViewController *)[[[self viewControllers][mapIndex] viewControllers] firstObject];

  [self configureMapController:mapController];
}

- (void)configureMapController:(APPSMapViewController *)controller {
  controller.configurator = [[APPSMapConfigurator alloc] init];
  controller.state = [[APPSMapSegueState alloc] init];
  APPSMapDelegate *delegate = [[APPSMapDelegate alloc] initWithParentController:controller];
  controller.delegate = delegate;
  controller.hidesBottomBarWhenPushed = YES;
}

- (void)configureCameraController {
  APPSCameraViewController *cameraController =
      (APPSCameraViewController *)self.viewControllers[cameraIndex];
  [self configureCameraController:cameraController];
}

- (void)configureCameraController:(APPSCameraViewController *)cameraViewController {
  cameraViewController.configurator = [[APPSCameraConfigurator alloc] init];
  cameraViewController.state = [[APPSCameraSegueState alloc] init];
}

- (void)configureNewsfeedController {
  UINavigationController *newsFeedNavigationViewController = self.viewControllers[newsFeedIndex];
  APPSStrategyTableViewController *feed =
      [newsFeedNavigationViewController.viewControllers firstObject];
  [self configureNewsfeedController:feed];
}

- (void)configureNewsfeedController:(APPSStrategyTableViewController *)newsfeedController {
  APPSNewsFeedViewControllerDelegate *feedDelegate =
      [[APPSNewsFeedViewControllerDelegate alloc] init];
  newsfeedController.delegate = feedDelegate;
  newsfeedController.dataSource = feedDelegate;
  newsfeedController.configurator = [[APPSNewsFeedViewControllerConfigurator alloc] init];
  newsfeedController.state = [[APPSNewsFeedSegueState alloc] init];
}

- (void)createViewControllers {
  UINavigationController *homeController = [self createHomeViewController];
  UINavigationController *map = [self createStartMapViewController];
  APPSCameraViewController *camera = [self createCameraViewController];
  UINavigationController *newsfeed = [self createNewsfeedViewController];
  UINavigationController *profile = [self createProfileViewController];
  self.viewControllers = @[ homeController, map, camera, newsfeed, profile ];
}

- (UIStoryboard *)mainStoryboard {
  return [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
}

- (UINavigationController *)createHomeViewController {
  return
      [[self mainStoryboard] instantiateViewControllerWithIdentifier:kProfileStoryboardIdentifier];
}

- (UINavigationController *)createStartMapViewController {
  return [[self mainStoryboard] instantiateViewControllerWithIdentifier:kMapScreenIdentifier];
}

- (APPSCameraViewController *)createCameraViewController {
  return [[self mainStoryboard] instantiateViewControllerWithIdentifier:kCameraScreenIdentifier];
}

- (UINavigationController *)createNewsfeedViewController {
  return [[self mainStoryboard] instantiateViewControllerWithIdentifier:kNewsfeedScreenIdentifier];
}

- (UINavigationController *)createProfileViewController {
  return
      [[self mainStoryboard] instantiateViewControllerWithIdentifier:kProfileStoryboardIdentifier];
}

- (UIViewController *)createViewControllerWithIndex:(NSUInteger)index {
  switch (index) {
    case homeIndex: {
      UINavigationController *homeController = [self createHomeViewController];
      [self configureHomeViewController:[homeController.viewControllers firstObject]];
      return homeController;
    }
    case mapIndex: {
      UINavigationController *mapController = [self createStartMapViewController];
      [self configureMapController:[[mapController viewControllers] firstObject]];
      return mapController;
    }
    case cameraIndex: {
      APPSCameraViewController *cameraController = [self createCameraViewController];
      [self configureCameraController:cameraController];
      return cameraController;
    }
    case newsFeedIndex: {
      UINavigationController *newsfeedController = [self createNewsfeedViewController];
      [self configureNewsfeedController:[newsfeedController.viewControllers firstObject]];
      return newsfeedController;
    }
    case profileIndex: {
      UINavigationController *profileController = [self createProfileViewController];
      [self customizeProfileViewController:[profileController.viewControllers firstObject]];
      return profileController;
    }
    default:
      NSLog(@"%@", [NSError errorWithDomain:@"APPSTabBarViewController"
                                       code:0
                                   userInfo:@{
                                     NSLocalizedFailureReasonErrorKey : @"Unsupported index"
                                   }]);
      return nil;
  }
}

- (void)customizeProfileViewController {
  UINavigationController *profileNavigationViewController = self.viewControllers[profileIndex];
  APPSProfileViewController *profileViewController =
      profileNavigationViewController.viewControllers[0];
  [self customizeProfileViewController:profileViewController];
}

- (void)customizeProfileViewController:(APPSProfileViewController *)profileViewController {
  if (!profileViewController.configurator) {
    APPSProfileViewControllerConfigurator *profileViewControllerConfigurator =
        [[APPSProfileViewControllerConfigurator alloc] init];
    profileViewController.configurator = profileViewControllerConfigurator;
  }
  if (!profileViewController.delegate) {
    APPSProfileViewControllerDelegate *profileViewControllerDelegate =
        [[APPSProfileViewControllerDelegate alloc]
            initWithViewController:profileViewController
                              user:[[APPSCurrentUserManager sharedInstance] currentUser]];
    profileViewController.delegate = profileViewControllerDelegate;
    profileViewController.dataSource = profileViewControllerDelegate;
  }
  if (!profileViewController.state) {
    profileViewController.state = [[APPSProfileSegueState alloc] init];
  }
}

- (void)customizeTabBarItem:(UITabBarItem *)item
                      title:(NSString *)title
                      image:(UIImage *)image
              selectedImage:(UIImage *)selectedImage {
  item.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  item.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  [item setTitleTextAttributes:@{
    NSForegroundColorAttributeName : UIColorFromRGB(101.f, 24.f, 4.f, 1.f)
  } forState:UIControlStateNormal];
  [item setTitleTextAttributes:@{
    NSForegroundColorAttributeName : [UIColor whiteColor]
  } forState:UIControlStateSelected];
  [item setTitle:title];
}

#pragma mark - Bubble View

- (void)initTabbarBubbleView {
  APPSNotificationUtility *notificationUtility =
      [[APPSUtilityFactory sharedInstance] notificationUtility];

  UIView *newsFeedItem = self.tabBar.subviews[newsFeedIndex];
  CGFloat xPosition =
      CGRectGetMinX(newsFeedItem.frame) + (CGRectGetWidth(newsFeedItem.frame) - imageSideSize) / 2;
  notificationUtility.bubbleView = [[APPSTabbarBubble alloc] initWithXPosition:xPosition];
  [self.tabBar insertSubview:notificationUtility.bubbleView atIndex:0];
}

- (void)tabBarController:(UITabBarController *)tabBarController
    didSelectViewController:(UIViewController *)viewController {
  if ([viewController isKindOfClass:[APPSNavigationViewController class]]) {
    APPSNavigationViewController *navigationViewController =
        (APPSNavigationViewController *)viewController;
    [navigationViewController
        popToViewController:[navigationViewController.viewControllers firstObject]
                   animated:NO];
  }

  if ([self.viewControllers indexOfObject:viewController] == newsFeedIndex) {
    APPSNotificationUtility *utility = [[APPSUtilityFactory sharedInstance] notificationUtility];
    [utility resetNotifications];

    if ([utility isBubbleShown]) {
      [utility hideBubbleView];
      APPSStrategyTableViewController *tableViewController =
          [((APPSNavigationViewController *)viewController).viewControllers firstObject];
      APPSNewsFeedViewControllerDelegate *delegate =
          (APPSNewsFeedViewControllerDelegate *)((APPSStrategyTableViewController *)
                                                     tableViewController).delegate;
      [delegate reloadUsersListUsingFilter:@"mine"];
    }
  }
}

#pragma mark - Handle application state changing

- (void)applicationDidBecomeActive:(NSNotification *)notification {
  APPSNotificationUtility *utility = [APPSUtilityFactory sharedInstance].notificationUtility;
  if (utility.openedAppFromPush) {
    if (self.selectedIndex == newsFeedIndex) {
      APPSNavigationViewController *navigationController = self.viewControllers[newsFeedIndex];
      APPSStrategyTableViewController *tableViewController =
          navigationController.viewControllers[0];
      [tableViewController reloadTable];
    } else {
      self.selectedViewController = self.viewControllers[newsFeedIndex];
    }
  } else if (utility.lastNotification) {
    [utility showBubbeView];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self cleanSystemMemory];
}

- (void)cleanSystemMemory {
  if (self.isClean) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMemoryWarningNotificationName
                                                        object:self];
  } else {
    NSUInteger selectedIndex = self.selectedIndex;
    UIViewController *selectedViewController = self.selectedViewController;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    for (NSInteger i = 0; i < self.viewControllers.count; i++) {
      if (i != selectedIndex) {
        UIViewController *viewController = [[UIViewController alloc] init];
        [viewControllers addObject:viewController];
      } else {
        [viewControllers addObject:selectedViewController];
      }
    }
    [self setViewControllers:[viewControllers copy] animated:NO];
    [self configureTabBar];
    self.isClean = YES;
  }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
  NSUInteger selectedViewControllerIndex =
      [self.viewControllers indexOfObject:selectedViewController];
  if ([selectedViewController isMemberOfClass:[UIViewController class]]) {
    self.isClean = NO;
    if (selectedViewControllerIndex == NSNotFound) {
      NSLog(@"%@",
            [NSError errorWithDomain:@"APPSTabBarViewController"
                                code:1
                            userInfo:@{
                              NSLocalizedFailureReasonErrorKey :
                                  @"View controller is not in tab bar " @"view controllers array"
                            }]);
    } else {
      UIViewController *viewControler =
          [self createViewControllerWithIndex:selectedViewControllerIndex];
      if (viewControler) {
        NSMutableArray *viewControllers =
            [NSMutableArray arrayWithCapacity:self.viewControllers.count];
        for (NSInteger i = 0; i < self.viewControllers.count; i++) {
          if (i != selectedViewControllerIndex) {
            [viewControllers addObject:self.viewControllers[i]];
          } else {
            [viewControllers addObject:viewControler];
          }
        }
        [self setViewControllers:[viewControllers copy] animated:NO];
        [self configureTabBar];
        selectedViewController = viewControler;
      }
    }
  }
  if (self.selectedIndex != selectedViewControllerIndex) {
    [[self.tabBar viewWithTag:cameraIndex] removeFromSuperview];
  }
  if (selectedViewControllerIndex != mapIndex) {
    self.previousTabIndex = NSNotFound;
  }
  [super setSelectedViewController:selectedViewController];
}

- (void)showMapPreviousTab {
  NSUInteger index = self.previousTabIndex < self.viewControllers.count ? self.previousTabIndex : homeIndex;
  UIViewController *previousViewController = (UIViewController *)self.viewControllers[index];
  [self setSelectedViewController:previousViewController];
}

@end
