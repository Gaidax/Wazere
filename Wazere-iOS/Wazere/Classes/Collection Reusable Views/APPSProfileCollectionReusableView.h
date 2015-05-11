//
//  APPSProfileCollectionReusableView.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/9/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPSCollectionReusableViewDelegate.h"
#import "APPSSegmentSuplementaryView.h"

@class APPSProfileCollectionReusableView;

@protocol APPSProfileCollectionReusableViewDelegate<APPSCollectionReusableViewDelegate>

- (void)reusableView:(APPSProfileCollectionReusableView *)reusableView
       profileAction:(UIButton *)button;
- (void)reusableView:(APPSProfileCollectionReusableView *)reusableView
          likeAction:(UIButton *)sender;

- (void)reusableViewFollowersAction:(APPSProfileCollectionReusableView *)reusableView;
- (void)reusableViewFollowingAction:(APPSProfileCollectionReusableView *)reusableView;

@end

@interface APPSProfileCollectionReusableView : UICollectionReusableView

@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property(weak, nonatomic) IBOutlet UILabel *photosLabel;
@property(weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property(weak, nonatomic) IBOutlet UILabel *followersLabel;
@property(weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property(weak, nonatomic) IBOutlet UILabel *followingLabel;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *personalDataLabel;
@property(weak, nonatomic) IBOutlet UIButton *profileButton;
@property(weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property(weak, nonatomic) IBOutlet UILabel *viewsCountLabel;

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet APPSSegmentSuplementaryView *bottomViewContainer;

@property(weak, nonatomic) id<APPSProfileCollectionReusableViewDelegate> delegate;

@end
