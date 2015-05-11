//
//  APPSCommentTableViewCell.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>
static CGFloat const kMinimumHeight = 82.0;
static CGFloat const kAutocompleteHeight = 41.0;
static CGFloat const kCommentLabelWidth = 246.0;
static CGFloat const kTopCommentLabelMargin = 36.0;
static CGFloat const kBottomCommentLabelMargin = 24.0;

@class APPSCommentTableViewCell;

@protocol APPSCommentTableViewCellDelegate<NSObject>

- (void)commentCell:(APPSCommentTableViewCell *)commentCell
     detectsHotWord:(STTweetHotWord)hotWord
           withText:(NSString *)text;
- (void)commentCell:(APPSCommentTableViewCell *)commentCell usernameAction:(UIButton *)sender;

@end

@interface APPSCommentTableViewCell : SWTableViewCell

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIImageView *userImageView;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *userImageButton;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UILabel *usernameLabel;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *usernameButton;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet STTweetLabel *userCommentLabel;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UILabel *createdAtLabel;

@property(strong, NS_NONATOMIC_IOSONLY) NSIndexPath *indexPath;

@property(assign, NS_NONATOMIC_IOSONLY) BOOL needsPlaceholder;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL topAligned;

@property(weak, NS_NONATOMIC_IOSONLY) id<APPSCommentTableViewCellDelegate> cellDelegate;

@end
