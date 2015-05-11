//
//  APPSGridCell.m
//  Wazere
//
//  Created by iOS Developer on 11/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSGridCell.h"
#import "APPSPhotoImageView.h"

@implementation APPSGridCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    super.backgroundColor = [UIColor whiteColor];
    CGFloat cellCornerRadius = 5.0;
    self.layer.cornerRadius = cellCornerRadius;
    self.clipsToBounds = YES;
    [self createGridImage];
    [self createUserView];
    [self createPhotoInfoView];
    [self layoutViews];
  }
  return self;
}

- (void)createGridImage {
  NSString *gridImageName = @"GridImage";
  [self createViewFormNibWithName:gridImageName];
}

- (void)createUserView {
  NSString *userViewName = @"UserView";
  [self createViewFormNibWithName:userViewName];
  self.userImage.layer.cornerRadius = CGRectGetHeight(self.userImage.frame) / 2.0;
  self.userImage.clipsToBounds = YES;
  self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
  self.userImage.layer.borderWidth = 1.0;
  CGFloat fontSize = 11.0;
  self.usernameLabel.font = FONT_HELVETICANEUE(fontSize);
  self.usernameLabel.textColor = UIColorFromRGB(33, 32, 32, 1.0);
}

- (void)createPhotoInfoView {
  NSString *photoInfoViewName = @"PhotoInformationView";
  [self createViewFormNibWithName:photoInfoViewName];
  CGFloat buttonsFontSize = 17.5;
  self.viewsButton.titleLabel.font = self.likesButton.titleLabel.font =
      self.commentsButton.titleLabel.font = FONT_CHAMPAGNE_LIMOUSINES(buttonsFontSize);
  [self.viewsButton setTitleColor:UIColorFromRGB(81, 81, 81, 1.0) forState:UIControlStateNormal];
  [self.commentsButton setTitleColor:UIColorFromRGB(81, 81, 81, 1.0) forState:UIControlStateNormal];

  [self.likesButton setTitleColor:UIColorFromRGB(198, 76, 68, 1.0) forState:UIControlStateNormal];
}

- (UIView *)createViewFormNibWithName:(NSString *)name {
  UIView *view =
      (UIImageView *)[[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] firstObject];
  if (view == nil) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSGridCell"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"View not loaded"
                                 }]);
    return nil;
  }
  [[self contentView] addSubview:view];
  return view;
}

- (void)layoutViews {
  CGFloat fullHeight = CGRectGetHeight(self.gridImage.frame) +
                       CGRectGetHeight(self.userView.frame) +
                       CGRectGetHeight(self.photoInformationView.frame);
  CGFloat heightScale = CGRectGetHeight(self.contentView.frame) / fullHeight;
  CGFloat widthScale =
      CGRectGetWidth(self.contentView.frame) / CGRectGetWidth(self.gridImage.frame);
  self.gridImage.frame = CGRectMake(0, 0, CGRectGetWidth(self.gridImage.frame) * widthScale,
                                    CGRectGetHeight(self.gridImage.frame) * heightScale);
  self.userView.frame = CGRectMake(0, CGRectGetMaxY(self.gridImage.frame),
                                   CGRectGetWidth(self.userView.frame) * widthScale,
                                   CGRectGetHeight(self.userView.frame) * heightScale);
  self.photoInformationView.frame =
      CGRectMake(0, CGRectGetMaxY(self.userView.frame),
                 CGRectGetWidth(self.photoInformationView.frame) * widthScale,
                 CGRectGetHeight(self.photoInformationView.frame) * heightScale);
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.userImage.layer.cornerRadius = CGRectGetHeight(self.userImage.frame) / 2.0;
}

@end
