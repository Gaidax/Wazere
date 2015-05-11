//
//  APPSMapFiltersView.m
//  Wazere
//
//  Created by iOS Developer on 9/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapFiltersView.h"
#import "UIImage+ImageFromColor.h"

@interface APPSMapFiltersView ()

@property(strong, NS_NONATOMIC_IOSONLY) NSMutableString *allPhototsTimeFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSMutableString *myPhotosTimeFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSMutableString *followingTimeFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSMutableString *mostLikedTimeFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSMutableString *mostViewedTimeFilter;
@property(strong, NS_NONATOMIC_IOSONLY) NSMutableString *currentTimeFilter;

@end

@implementation APPSMapFiltersView

static CGFloat const normalHeight = 64.0;
static CGFloat const expandedHeight = 128.0;

- (void)awakeFromNib {
  [super awakeFromNib];
  [self configureButton:self.allPhotosFilter
                      withTitle:@"all photos"
           normalStateImageName:@"all_photos_icon"
      highlightedStateImageName:@"all_photos_icon_pressed"];
  [self configureButton:self.myPhotosFilter
                      withTitle:@"my photos"
           normalStateImageName:@"my_photos_icon"
      highlightedStateImageName:@"my_photos_icon_pressed"];
  [self configureButton:self.myFiendsPhotoFilter
                      withTitle:@"my friends\nphotos"
           normalStateImageName:@"my_friends_icon"
      highlightedStateImageName:@"my_friends_icon_pressed"];
  [self configureButton:self.mostPopularFilter
                      withTitle:@"most\npopular"
           normalStateImageName:@"popular_photos_icon"
      highlightedStateImageName:@"popular_photos_icon_pressed"];
  [self configureButton:self.mostViewedFilter
                      withTitle:@"most\nviewed"
           normalStateImageName:@"most_viewed_photos_icon"
      highlightedStateImageName:@"most_viewed_photos_icon_pressed"];

  self.yesterdayLabel.font = self.lastWeekLabel.font = self.lastMonthLabel.font =
      self.allTimeLabel.font = [UIFont fontWithName:@"INTRO" size:8.0];

  self.yesterdayLabel.textColor = [self buttonsNormalColor];
  self.lastWeekLabel.textColor = [self buttonsNormalColor];
  self.lastMonthLabel.textColor = [self buttonsNormalColor];
  self.allTimeLabel.textColor = [self buttonsNormalColor];
  [self deselectAllExceptDateFilter:nil];
  [self deselectAllExceptFilter:nil];
  [self initializeDateFilters];
  self.currentFilter = allFilter;
  [self.allPhototsTimeFilter setString:@""];
}

- (void)initializeDateFilters {
  self.allPhototsTimeFilter = [[NSMutableString alloc] init];
  self.myPhotosTimeFilter = [[NSMutableString alloc] init];
  self.followingTimeFilter = [[NSMutableString alloc] init];
  self.mostLikedTimeFilter = [[NSMutableString alloc] init];
  self.mostViewedTimeFilter = [[NSMutableString alloc] init];
}

- (UIFont *)buttonsFont {
  return [UIFont fontWithName:@"INTRO" size:9.0];
}

- (UIColor *)buttonsNormalColor {
  return [UIColor colorWithRed:99.0 / 255 green:95.0 / 255 blue:93.0 / 255 alpha:1.0];
}

- (UIColor *)buttonsHighlitedColor {
  return [UIColor whiteColor];
}

- (void)configureButton:(UIButton *)button
                    withTitle:(NSString *)title
         normalStateImageName:(NSString *)normalImageName
    highlightedStateImageName:(NSString *)highlightedImageName {
  UIFont *buttonsFont = [self buttonsFont];
  UIColor *normalColor = [self buttonsNormalColor];
  UIColor *pressedColor = [self buttonsHighlitedColor];
  [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
  button.titleLabel.font = buttonsFont;
  button.titleLabel.numberOfLines = 2;
  button.titleLabel.textAlignment = NSTextAlignmentCenter;
  [button setTitleColor:normalColor forState:UIControlStateNormal];
  [button setTitleColor:normalColor forState:UIControlStateSelected];
  [button setTitleColor:pressedColor forState:UIControlStateHighlighted];
  [button setTitleColor:pressedColor forState:UIControlStateSelected | UIControlStateHighlighted];
  UIImage *normalBackgroundImage = [UIImage apps_imageWithColor:[UIColor whiteColor]];
  UIImage *highlightedBackgroundImage =
      [UIImage apps_imageWithColor:UIColorFromRGB(205, 68, 65, 1.0)];
  [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
  [button setBackgroundImage:normalBackgroundImage forState:UIControlStateSelected];
  [button setBackgroundImage:highlightedBackgroundImage
                    forState:UIControlStateSelected | UIControlStateHighlighted];
  UIImage *normalImage =
      [[[APPSUtilityFactory sharedInstance] imageUtility] imageNamed:normalImageName];
  UIImage *highlightedImage =
      [[[APPSUtilityFactory sharedInstance] imageUtility] imageNamed:highlightedImageName];
  [button setImage:normalImage forState:UIControlStateNormal];
  [button setImage:normalImage forState:UIControlStateSelected];
  [button setImage:highlightedImage forState:UIControlStateHighlighted];
  [button setImage:highlightedImage forState:UIControlStateSelected | UIControlStateHighlighted];
  CGFloat imageWidth = CGRectGetWidth(button.imageView.frame),
          normalButtonWidth = CGRectGetWidth(button.frame), normalWindowWidth = 320.0,
          scale = CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame) /
                  normalWindowWidth;
  CGFloat topImageInset = -30.0, topTitleInset = 30, horizontalTitleInset = -20,
          horizontalImageInset = (normalButtonWidth * scale - imageWidth) / 2.0;
  [button setTitleEdgeInsets:UIEdgeInsetsMake(topTitleInset, horizontalTitleInset, 0, 0)];
  [button setImageEdgeInsets:UIEdgeInsetsMake(topImageInset, horizontalImageInset, 0,
                                              horizontalImageInset)];
  button.layer.shadowOpacity = 0.5;
  button.layer.shadowOffset = CGSizeMake(1, 1);
}

- (void)setViewHeight:(CGFloat)height {
  self.allTimeFilter.hidden = self.yesterdayFilter.hidden = self.lastWeekFilter.hidden =
      self.lastMonthFilter.hidden = self.lastMonthLabel.hidden = self.yesterdayLabel.hidden =
          self.lastWeekLabel.hidden = self.lastMonthLabel.hidden = NO;
  [self.superview layoutIfNeeded];
  [UIView animateWithDuration:0.5
      animations:^{
          self.height.constant = height;
          [self.superview layoutIfNeeded];
      }
      completion:^(BOOL finished) {
          if (finished) {
            BOOL hidden = height == normalHeight;
            self.allTimeFilter.hidden = self.yesterdayFilter.hidden = self.lastWeekFilter.hidden =
                self.lastMonthFilter.hidden = self.lastMonthLabel.hidden =
                    self.yesterdayLabel.hidden = self.lastWeekLabel.hidden =
                        self.lastMonthLabel.hidden = hidden;
          }
      }];
}

- (void)deselectAllExceptFilter:(UIButton *)filter {
  if (self.allPhotosFilter != filter) {
    self.allPhotosFilter.selected = NO;
  }
  if (self.myPhotosFilter != filter) {
    self.myPhotosFilter.selected = NO;
  }
  if (self.myFiendsPhotoFilter != filter) {
    self.myFiendsPhotoFilter.selected = NO;
  }
  if (self.mostPopularFilter != filter) {
    self.mostPopularFilter.selected = NO;
  }
  if (self.mostViewedFilter != filter) {
    self.mostViewedFilter.selected = NO;
  }
  if (filter == nil) {
    [self setViewHeight:normalHeight];
  }
}

- (void)deselectAllExceptDateFilter:(UIButton *)dateFilter {
  dateFilter.selected = YES;
  if (self.allTimeFilter != dateFilter) {
    self.allTimeFilter.selected = NO;
  }
  if (self.yesterdayFilter != dateFilter) {
    self.yesterdayFilter.selected = NO;
  }
  if (self.lastWeekFilter != dateFilter) {
    self.lastWeekFilter.selected = NO;
  }
  if (self.lastMonthFilter != dateFilter) {
    self.lastMonthFilter.selected = NO;
  }
}

- (void)processTapOnFilter:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (sender.selected) {
    [self deselectAllExceptDateFilter:[self currentTimeFilterButton]];
    [self deselectAllExceptFilter:sender];
    [self.delegate mapFiltersView:self
                     selectFilter:self.currentFilter
                       dateFilter:self.currentTimeFilter];
    [self setViewHeight:expandedHeight];
  } else {
    [self setViewHeight:normalHeight];
  }
}

- (UIButton *)currentTimeFilterButton {
  self.currentTimeFilter = [self timeFilter];
  if (self.currentTimeFilter.length == 0) {
    self.currentTimeFilter = nil;
  }
  UIButton *timeFilterButton = [self timeFilterButtonForFilterModel:self.currentTimeFilter];
  return timeFilterButton;
}

- (NSMutableString *)timeFilter {
  NSMutableString *timeFilter;
  if ([self.currentFilter isEqualToString:allFilter]) {
    timeFilter = self.allPhototsTimeFilter;
  } else if ([self.currentFilter isEqualToString:mineFilter]) {
    timeFilter = self.myPhotosTimeFilter;
  } else if ([self.currentFilter isEqualToString:followingFilter]) {
    timeFilter = self.followingTimeFilter;
  } else if ([self.currentFilter isEqualToString:mostLikedFilter]) {
    timeFilter = self.mostLikedTimeFilter;
  } else if ([self.currentFilter isEqualToString:mostViewedFilter]) {
    timeFilter = self.mostViewedTimeFilter;
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSMapFiltersView"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Invalid photos filter"
                                 }]);
  }
  return timeFilter;
}

- (UIButton *)timeFilterButtonForFilterModel:(NSString *)timeFilter {
  UIButton *timeFilterButton;
  if (timeFilter.length == 0) {
    timeFilterButton = self.allTimeFilter;
  } else if ([timeFilter isEqualToString:yesterdayFilter]) {
    timeFilterButton = self.yesterdayFilter;
  } else if ([timeFilter isEqualToString:lastWeekFilter]) {
    timeFilterButton = self.lastWeekFilter;
  } else if ([timeFilter isEqualToString:lastMonthFilter]) {
    timeFilterButton = self.lastMonthFilter;
  } else {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSMapFiltersView"
                                     code:1
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Invalid time filter model"
                                 }]);
  }
  return timeFilterButton;
}

- (IBAction)tapsAllPhotosFilter:(UIButton *)sender {
  self.currentFilter = allFilter;
  [self processTapOnFilter:sender];
}

- (IBAction)tapsMyPhotosFilter:(UIButton *)sender {
  self.currentFilter = mineFilter;
  [self processTapOnFilter:sender];
}

- (IBAction)tapsMyFriendsPhotosFilter:(UIButton *)sender {
  self.currentFilter = followingFilter;
  [self processTapOnFilter:sender];
}

- (IBAction)tapsMostPopularFilter:(UIButton *)sender {
  self.currentFilter = mostLikedFilter;
  [self processTapOnFilter:sender];
}

- (IBAction)tapsMostViewedFilter:(UIButton *)sender {
  self.currentFilter = mostViewedFilter;
  [self processTapOnFilter:sender];
}

- (IBAction)tapsYesterdayFilter:(UIButton *)sender {
  [self deselectAllExceptDateFilter:sender];
  [self.delegate mapFiltersView:self selectFilter:self.currentFilter dateFilter:yesterdayFilter];
  [[self timeFilter] setString:yesterdayFilter];
  self.currentTimeFilter = nil;
  self.currentFilter = nil;
  [self deselectAllExceptFilter:nil];
}

- (IBAction)tapsLastWeekFilter:(UIButton *)sender {
  [self deselectAllExceptDateFilter:sender];
  [self.delegate mapFiltersView:self selectFilter:self.currentFilter dateFilter:lastWeekFilter];
  [[self timeFilter] setString:lastWeekFilter];
  self.currentTimeFilter = nil;
  self.currentFilter = nil;
  [self deselectAllExceptFilter:nil];
}

- (IBAction)tapsLastMonthFilter:(UIButton *)sender {
  [self deselectAllExceptDateFilter:sender];
  [self.delegate mapFiltersView:self selectFilter:self.currentFilter dateFilter:lastMonthFilter];
  [[self timeFilter] setString:lastMonthFilter];
  self.currentTimeFilter = nil;
  self.currentFilter = nil;
  [self deselectAllExceptFilter:nil];
}

- (IBAction)tapsAllTimeFilter:(UIButton *)sender {
  [self deselectAllExceptDateFilter:sender];
  [self.delegate mapFiltersView:self selectFilter:self.currentFilter dateFilter:nil];
  [[self timeFilter] setString:@""];
  self.currentTimeFilter = nil;
  self.currentFilter = nil;
  [self deselectAllExceptFilter:nil];
}

@end
