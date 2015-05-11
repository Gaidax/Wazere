//
//  APPSProfileRectCollectionViewCell.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/9/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPSProfileRectCollectionViewCell, APPSResizableLabel, PPLabel, APPSPhotoImageView;

static NSString *const kHotWordTypeAttribute = @"HotWordTypeAttribute";
static NSString *const kHotWordValueAttribute = @"HotWordValueAttribute";

@protocol APPSProfileRectCollectionViewCellDelegate<NSObject>

- (void)commentCell:(APPSProfileRectCollectionViewCell *)cell
     detectsHotWord:(HotWordType)hotWord
           withText:(NSString *)text;
- (void)cellLikeUnlikeAction:(APPSProfileRectCollectionViewCell *)cell withImageAnimation:(BOOL)imageAnimation;
- (void)cellPhotoLikesAction:(APPSProfileRectCollectionViewCell *)cell;
- (void)cellPhotoViewsAction:(APPSProfileRectCollectionViewCell *)cell;
- (void)cellCommentsPhoto:(APPSProfileRectCollectionViewCell *)cell;
- (void)cellTapsMoreOptions:(APPSProfileRectCollectionViewCell *)cell;
- (void)profileActionInCell:(APPSProfileRectCollectionViewCell *)cell;
- (void)locationSelectedInCell:(APPSProfileRectCollectionViewCell *)cell;

@end

@interface APPSProfileRectCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *userImageView;
@property(weak, nonatomic) IBOutlet UILabel *topUserNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *timePassedLabel;
@property(weak, nonatomic) IBOutlet UILabel *locationLabel;
@property(weak, nonatomic) IBOutlet UIImageView *locationIcon;

@property(weak, nonatomic) IBOutlet APPSPhotoImageView *imageView;

@property(weak, nonatomic) IBOutlet APPSResizableLabel *commentsLabel;
@property(weak, nonatomic) IBOutlet UIButton *likeButton;
@property(weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property(weak, nonatomic) IBOutlet UIButton *commentButton;
@property(weak, nonatomic) IBOutlet UIButton *moreOptionsButton;

@property(weak, nonatomic) IBOutlet APPSResizableLabel *descriptionLabel;
@property(weak, nonatomic) IBOutlet UIButton *watchedCountButton;

@property(weak, nonatomic) id<APPSProfileRectCollectionViewCellDelegate> delegate;

@end
