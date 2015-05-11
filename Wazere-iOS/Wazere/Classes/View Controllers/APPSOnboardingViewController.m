//
//  APPSOnboardingViewController.m
//  Wazere
//
//  Created by Gaidax on 4/6/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSOnboardingViewController.h"
#import "APPSPageControl.h"

#import <RACEXTScope.h>

@interface APPSOnboardingViewController ()
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) BOOL lastPageIsOpened;
@end

@implementation APPSOnboardingViewController
static NSString *const APPSOnboardingImageName = @"%@_onboarding_screen_%@.jpg";
static NSInteger const APPSOnboardingImageCount = 6;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupOnboardingScreen];
    [self drawGradient];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.skipButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)drawGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *startColour = [UIColor colorWithRed:0.749 green:0.263 blue:0.220 alpha:1.000];
    UIColor *endColour = [UIColor colorWithRed:0.667 green:0.149 blue:0.227 alpha:1.000];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)setupOnboardingScreen {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:APPSOnboardingImageCount];
    
    self.hidePageControl = NO;
    self.swipingEnabled = YES;
    self.shouldFadeTransitions = YES;
    
    self.allowSkipping = ![[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstLoadKey];
    
    for (NSInteger onboardingIndex = 1; onboardingIndex <= APPSOnboardingImageCount; onboardingIndex ++) {
        NSString *imageName = [NSString stringWithFormat:APPSOnboardingImageName,
                                                       @(onboardingIndex),
                                                       [self deviceIdentifiers][@(SCREEN_MAX_LENGTH)]];
        OnboardingContentViewController *contentViewController =
        [[OnboardingContentViewController alloc] initWithTitle:nil
                                                          body:nil
                                                         image:[UIImage imageNamed:imageName]
                                                    buttonText:nil
                                                        action:nil];
        [viewControllers addObject:contentViewController];
    }
    
    self.viewControllers = [viewControllers copy];
    self.topPadding = 0;
    self.pageControl = [[APPSPageControl alloc] init];
    
    self.skipButton = [[UIButton alloc] init];
    [self.skipButton setImage:[UIImage imageNamed:@"skip_button"]
                     forState:UIControlStateNormal];
    @weakify(self);
    self.skipHandler = ^{
        @strongify(self);
        [self dismissViewController];
    };
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    [super pageViewController:pageViewController didFinishAnimating:finished
      previousViewControllers:previousViewControllers transitionCompleted:completed];
    UIViewController *viewController = [pageViewController.viewControllers lastObject];
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    self.lastPageIsOpened = index == APPSOnboardingImageCount - 1;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    if (self.lastContentOffset < scrollView.contentOffset.x && self.lastPageIsOpened) {
        [self dismissViewController];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.x;
}

#pragma mark - Helpers

- (void)dismissViewController {
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    completion:^(BOOL finished) {
                        [[[APPSUtilityFactory sharedInstance] locationUtility] startStandardUpdatesWithDesiredAccuracy:kCLLocationAccuracyBestForNavigation distanceFilter:5 handler:^(CLLocation *location, NSError *error) {
                            [[[APPSUtilityFactory sharedInstance] locationUtility] stopUpdates];
                        }];
                    }];
}

- (NSDictionary *)deviceIdentifiers {
    return @{
             @(480) : @"4",
             @(568) : @"5",
             @(667) : @"6",
             @(736) : @"6+"
             };
}

@end
