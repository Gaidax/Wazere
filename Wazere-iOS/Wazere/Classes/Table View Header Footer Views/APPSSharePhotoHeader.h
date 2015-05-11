//
//  APPSSharePhotoTableViewCell.h
//  Wazere
//
//  Created by iOS Developer on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APPSharePhotoHeaderDelegare<NSObject>
- (void)chooseNewLocationViewTouched;
- (void)changeShareLocationStatus:(BOOL)status;
@end

static NSInteger const kMaxDescriptionLength = 140;

@class APPSSharePhotoModel, APPSSharePhotoTextField;

@interface APPSSharePhotoHeader : UITableViewHeaderFooterView

@property(nonatomic, readonly, retain) IBOutlet UIView *contentView;
@property(weak, nonatomic) id<APPSharePhotoHeaderDelegare> delegate;

@property(weak, nonatomic) IBOutlet UISwitch *bindLocationSwitch;

@property(weak, nonatomic) IBOutlet UIView *descriptionContainer;
@property(weak, nonatomic) IBOutlet UIImageView *photo;
@property(weak, nonatomic) IBOutlet UIView *shareContainer;
@property(weak, nonatomic) IBOutlet UITextView *descriptionView;

@property(weak, nonatomic) IBOutlet APPSSharePhotoTextField *locationAlias;

@property(weak, nonatomic) IBOutlet UIView *selectLocationView;
@property(weak, nonatomic) IBOutlet UILabel *selectLocationLabel;

@property(weak, nonatomic) IBOutlet UIButton *facebookButton;
@property(weak, nonatomic) IBOutlet UIButton *twitterButton;

@property(strong, nonatomic) APPSSharePhotoModel *model;

@end
