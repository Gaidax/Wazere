//
//  APPSSearchResultTableViewCell.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSearchResultTableViewCell.h"
#import "APPSSomeUser.h"
#import "APPSSearchConstants.h"

@interface APPSSearchResultTableViewCell ()
@property(weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property(weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet UIButton *followButton;
@end

@implementation APPSSearchResultTableViewCell

static NSInteger const touchableViewTag = 10;

- (void)awakeFromNib {
  CALayer *imageLayer = self.avatarImageView.layer;
  imageLayer.cornerRadius = 22.f;
  imageLayer.borderWidth = 0.f;
  imageLayer.masksToBounds = YES;

  UINib *nib = [UINib nibWithNibName:@"APPSImageCollectionViewCell" bundle:nil];
  [self.collectionView registerNib:nib
        forCellWithReuseIdentifier:kFacebookSearchCollectionViewCell];
}

- (void)setUserModel:(APPSSomeUser *)userModel {
  _userModel = userModel;
  self.followButton.selected = self.rightViewSelected;

  self.userNameLabel.text = userModel.username;
  [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar]
                          placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")];
}


- (void)setRightViewMode:(APPSSearchResultRightViewMode)rightViewMode {
  _rightViewMode = rightViewMode;
    
    APPSCurrentUser *currentUser = [APPSCurrentUserManager sharedInstance].currentUser;
    self.followButton.hidden = [currentUser.userId isEqualToNumber:self.userModel.userId];

  if (rightViewMode == APPSSearchResultRightViewModeRadio) {
    self.followButton.backgroundColor = [UIColor clearColor];
    [self.followButton setImage:IMAGE_WITH_NAME(@"circle") forState:UIControlStateNormal];
    [self.followButton setImage:IMAGE_WITH_NAME(@"circle_check") forState:UIControlStateSelected];
  }
}

- (IBAction)followButtonPressed:(id)sender {
  if ([self.delegate respondsToSelector:@selector(reusableView:followAction:)]) {
    [self.delegate reusableView:self followAction:sender];
  }
}

- (void)setCollectionViewDataSourceDelegate:
            (id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
                                      index:(NSInteger)index {
  self.collectionView.delegate = dataSourceDelegate;
  self.collectionView.dataSource = dataSourceDelegate;
  self.collectionView.tag = index;

  [self.collectionView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];

  if (touch.view.tag == touchableViewTag) {
    if ([self.delegate respondsToSelector:@selector(profileActionInCell:)]) {
      [self.delegate profileActionInCell:self];
    }
  }
  [super touchesBegan:touches withEvent:event];
}

@end
