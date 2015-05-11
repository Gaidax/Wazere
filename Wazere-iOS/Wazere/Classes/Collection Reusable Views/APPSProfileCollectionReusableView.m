//
//  APPSProfileCollectionReusableView.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/9/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileCollectionReusableView.h"

@interface APPSProfileCollectionReusableView () <APPSSegmentSuplementaryViewDelegate>

@end

@implementation APPSProfileCollectionReusableView
static NSInteger const followersViewsTag = 10;
static NSInteger const followingViewsTag = 20;

- (void)awakeFromNib {
  [self configureBottomContainerView];
  [self labelsConfigurate];
  [self buttonssConfigurate];
}

- (void)configureBottomContainerView {
  self.bottomViewContainer.delegate = self;
}

- (void)labelsConfigurate {
  _photoCountLabel.font = _followerCountLabel.font = _followingCountLabel.font =
      FONT_CHAMPAGNE_LIMOUSINES(25.f);
  _photosLabel.font = _followersLabel.font = _followingLabel.font = FONT_HELVETICANEUE_LIGHT(12.f);
}

- (void)buttonssConfigurate {
  _profileButton.layer.shadowOpacity = 0.14;
  _profileButton.layer.shadowRadius = 0.0;
  _profileButton.layer.shadowOffset = CGSizeMake(3, 3);
  _profileButton.layer.shadowColor = [UIColor blackColor].CGColor;
  _profileButton.layer.cornerRadius = 6.f;
  _profileButton.titleLabel.font = FONT_HELVETICANEUE(12.f);
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.photoImageView.image = IMAGE_WITH_NAME(@"photo_placeholder");
  self.nameLabel.text = nil;
  self.personalDataLabel.text = nil;
  self.photoCountLabel.text = nil;
  self.followerCountLabel.text = nil;
  self.followingCountLabel.text = nil;
  self.followersLabel.userInteractionEnabled =
  self.followingLabel.userInteractionEnabled =
  self.followerCountLabel.userInteractionEnabled =
  self.followingCountLabel.userInteractionEnabled = NO;
  self.profileButton.hidden = YES;
  self.profileButton.enabled = NO;
}

#pragma mark - Actions

- (void)likeAction:(UIButton *)sender {
  [self.delegate reusableView:self likeAction:sender];
}

- (IBAction)profileAction:(id)sender {
  [self.delegate reusableView:self profileAction:sender];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];

  if (touch.view.tag == followersViewsTag) {
    [self.delegate reusableViewFollowersAction:self];
  } else if (touch.view.tag == followingViewsTag) {
    [self.delegate reusableViewFollowingAction:self];
  }

  [super touchesBegan:touches withEvent:event];
}

#pragma mark - APPSSegmentSuplementaryViewDelegate

- (NSArray *)suplementaryViewButtonItems {
  return @[ [UIImage imageNamed:@"new_grid"], [UIImage imageNamed:@"list_view"] ];
}

- (void)suplementaryView:(APPSSegmentSuplementaryView *)view
            valueChanged:(UISegmentedControl *)sender {
  sender.selectedSegmentIndex ? [self.delegate collectionReusableView:self listAction:nil]
                              : [self.delegate collectionReusableView:self gridAction:nil];
}

@end
