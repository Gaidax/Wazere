//
//  APPSMapFiltersView.h
//  Wazere
//
//  Created by iOS Developer on 9/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPSMapFiltersView;

static NSString *const allFilter = @"all";
static NSString *const mineFilter = @"mine";
static NSString *const followingFilter = @"following";
static NSString *const mostLikedFilter = @"most_liked";
static NSString *const mostViewedFilter = @"most_viewed";

static NSString *const yesterdayFilter = @"yesterday";
static NSString *const lastWeekFilter = @"last_week";
static NSString *const lastMonthFilter = @"last_month";

@protocol APPSMapFiltersViewDelegate<NSObject>

- (void)mapFiltersView:(APPSMapFiltersView *)filtersView
          selectFilter:(NSString *)filter
            dateFilter:(NSString *)dateFilter;

@end

@interface APPSMapFiltersView : UIView

@property(weak, nonatomic) IBOutlet UIButton *allPhotosFilter;
@property(weak, nonatomic) IBOutlet UIButton *myPhotosFilter;
@property(weak, nonatomic) IBOutlet UIButton *myFiendsPhotoFilter;
@property(weak, nonatomic) IBOutlet UIButton *mostPopularFilter;
@property(weak, nonatomic) IBOutlet UIButton *mostViewedFilter;

@property(weak, nonatomic) IBOutlet UIButton *yesterdayFilter;
@property(weak, nonatomic) IBOutlet UIButton *lastWeekFilter;
@property(weak, nonatomic) IBOutlet UIButton *lastMonthFilter;
@property(weak, nonatomic) IBOutlet UIButton *allTimeFilter;

@property(weak, nonatomic) IBOutlet UILabel *yesterdayLabel;
@property(weak, nonatomic) IBOutlet UILabel *lastWeekLabel;
@property(weak, nonatomic) IBOutlet UILabel *lastMonthLabel;
@property(weak, nonatomic) IBOutlet UILabel *allTimeLabel;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *height;

- (IBAction)tapsAllPhotosFilter:(UIButton *)sender;
- (IBAction)tapsMyPhotosFilter:(UIButton *)sender;
- (IBAction)tapsMyFriendsPhotosFilter:(UIButton *)sender;
- (IBAction)tapsMostPopularFilter:(UIButton *)sender;
- (IBAction)tapsMostViewedFilter:(UIButton *)sender;

- (IBAction)tapsYesterdayFilter:(UIButton *)sender;
- (IBAction)tapsLastMonthFilter:(UIButton *)sender;
- (IBAction)tapsLastWeekFilter:(UIButton *)sender;
- (IBAction)tapsAllTimeFilter:(UIButton *)sender;

@property(weak, nonatomic) id<APPSMapFiltersViewDelegate> delegate;
@property(strong, nonatomic) NSString *currentFilter;

- (NSMutableString *)timeFilter;

@end
