//
//  APPSNewsFeedTableViewCell.m
//  Wazere
//
//  Created by Alexey Kalentyev on 10/21/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSNewsFeedTableViewCell.h"
#import "APPSNewsFeedConstants.h"
#import "PPLabel.h"
#import "APPSPhotoImageView.h"
#import "NSDate+APPSRelativeDate.h"
#include <tgmath.h>

@interface APPSNewsFeedTableViewCell () <PPLabelDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(weak, nonatomic) IBOutlet PPLabel *messageLabel;
@property(weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property(weak, nonatomic) IBOutlet APPSPhotoImageView *commentedImageView;
@property(weak, nonatomic) IBOutlet UILabel *commentLabel;
@property(weak, nonatomic) IBOutlet UIButton *followButton;
@property(assign, nonatomic) NSRange highlightedRange;

@end

static NSString *const CreatedAtFormatString = @"%@ ago";
static NSInteger const LoadPhotoViewTag = 10;
static NSInteger const LoadProfileViewTag = 20;

static CGFloat const DefaultLabelWidth = 200.f;
static CGFloat const PhotoCollectionViewRowWidth = 63.f;

@implementation APPSNewsFeedTableViewCell

- (void)awakeFromNib {
  self.messageLabel.delegate = self;
  self.collectionView.scrollsToTop = NO;

  UINib *nib = [UINib nibWithNibName:@"APPSImageCollectionViewCell" bundle:nil];
  [self.collectionView registerNib:nib forCellWithReuseIdentifier:kFeedCollectionViewCell];
}

#pragma mark - Model

- (void)setCollectionViewDataSourceDelegate:
            (id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
                                      index:(NSInteger)index {
  self.collectionView.delegate = dataSourceDelegate;
  self.collectionView.dataSource = dataSourceDelegate;
  self.collectionView.tag = index;

  [self.collectionView reloadData];
}

- (void)setFeedModel:(APPSUserFeedsModel *)feedModel {
  _feedModel = feedModel;
  [self updateViewWithCurrentFeeds];
}

- (void)updateViewWithCurrentFeeds {
  [self.commentedImageView.activityIndicator stopAnimating];
  APPSNewsFeedType feedType = [self.feedModel.feedType integerValue];
  APPSNewsFeedModel *firstModel = [self.feedModel firstNewsFeedModel];

  self.commentedImageView.hidden = self.commentLabel.hidden = feedType != APPSNewsFeedTypeComment;
  self.followButton.hidden = !(feedType == APPSNewsFeedTypeFollow &&
                               self.cellType == APPSNewsFeedTableViewCellTypeYours) ||
                             [self.feedModel.user.isFollowed boolValue];
  self.followButton.selected = [self.feedModel.user.isFollowed boolValue];

  if (feedType == APPSNewsFeedTypeComment) {
    [self configureCommentViews:firstModel];
    self.commentLabel.text = firstModel.message;
  }

  if ((self.feedModel.feeds.count == 1 && feedType == APPSNewsFeedTypeLike) || feedType >= APPSNewsFeedTypeInvitePhoto) {
    self.commentedImageView.hidden = NO;
    [self configureCommentViews:firstModel];
  }

  self.messageLabel.attributedText = [self messageStringForCurrentModel];

  self.createdAtLabel.text = [NSString
      stringWithFormat:CreatedAtFormatString, [NSDate relativeDateFromString:firstModel.createdAt]];
  [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.feedModel.user.avatar]
                         placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")];
}

- (void)configureCommentViews:(APPSNewsFeedModel *)firstModel {
  [self.commentedImageView.activityIndicator startAnimating];
  [self.commentedImageView setShouldBlur:!firstModel.feedable.isAllowed];
  self.commentedImageView.notAvailableLabel.text = firstModel.feedable.tagline;
  [self.commentedImageView sd_setImageWithURL:[NSURL URLWithString:firstModel.feedable.photoUrl]
                                    completed:^(UIImage *image, NSError *error,
                                                SDImageCacheType cacheType, NSURL *imageURL) {
                                        if (!error) {
                                          [self.commentedImageView.activityIndicator stopAnimating];
                                        } else {
                                          NSLog(@"%@", error);
                                        }
                                    }];
}

- (NSMutableAttributedString *)messageStringForCurrentModel {
  NSMutableString *message = [NSMutableString new];
  NSInteger userNameLenght = [self.feedModel.user.username length];
  [message appendFormat:@"%@ ", self.feedModel.user.username];

  if (self.cellType == APPSNewsFeedTableViewCellTypeYours) {
    [message
        appendFormat:@"%@", [APPSNewsFeedTableViewCell
                                messageForYoursFeedType:[self.feedModel.feedType integerValue]]];
  } else {
    [message
        appendFormat:@"%@", [APPSNewsFeedTableViewCell messageForFollowedFeeds:self.feedModel]];
  }

  UIFont *usernameFont = FONT_HELVETICANEUE(14.f);
  UIFont *messageFont = FONT_HELVETICANEUE_LIGHT(14.f);

  NSMutableAttributedString *attributedString =
      [[NSMutableAttributedString alloc] initWithString:message];
  [attributedString addAttributes:@{
    NSForegroundColorAttributeName : UIColorFromRGB(114.f, 20.f, 5.f, 1.f),
    NSFontAttributeName : usernameFont
  } range:NSMakeRange(0, userNameLenght)];
  [attributedString addAttributes:@{
    NSForegroundColorAttributeName :
        [UIColor colorWithRed:0.188 green:0.176 blue:0.176 alpha:1.000],
    NSFontAttributeName : messageFont
  } range:NSMakeRange(userNameLenght, [message length] - userNameLenght)];

  for (APPSNewsFeedModel *newsFeed in self.feedModel.feeds) {
    NSRange range =
        [message rangeOfString:newsFeed.recipient.username
                       options:NSCaseInsensitiveSearch
                         range:NSMakeRange(userNameLenght, [message length] - userNameLenght)];

    if (range.location != NSNotFound) {
      [attributedString addAttributes:@{
        NSForegroundColorAttributeName : UIColorFromRGB(114.f, 20.f, 5.f, 1.f),
        NSFontAttributeName : usernameFont
      } range:range];
    }
  }
  return attributedString;
}

#pragma mark - Label Touches Processing

- (BOOL)label:(PPLabel *)label
         didBeginTouch:(UITouch *)touch
    onCharacterAtIndex:(CFIndex)charIndex {
  [self highlightWordContainingCharacterAtIndex:charIndex];
  return YES;
}

- (BOOL)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
  return NO;
}

- (BOOL)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
  [self removeHighlight];
  return YES;
}

- (BOOL)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
  [self removeHighlight];
  return YES;
}

- (void)highlightWordContainingCharacterAtIndex:(CFIndex)charIndex {
  if (charIndex == NSNotFound) {
    [self removeHighlight];
    return;
  }
  if ([self.delegate respondsToSelector:@selector(selectWord:inNewsFeedCell:)]) {
    [self.delegate
            selectWord:[self wordAtIndex:charIndex inString:self.messageLabel.attributedText.string]
        inNewsFeedCell:self];
  }
}

- (NSString *)wordAtIndex:(NSInteger)index inString:(NSString *)string {
  __block NSString *result = nil;
  [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange,
                                       NSRange enclosingRange, BOOL *stop) {
                              if (NSLocationInRange(index, enclosingRange)) {
                                result = substring;
                                *stop = YES;
                              }
                          }];
  return result;
}

- (void)removeHighlight {
  if (self.highlightedRange.location != NSNotFound) {
    NSMutableAttributedString *attributedString = [self.messageLabel.attributedText mutableCopy];
    [attributedString removeAttribute:NSBackgroundColorAttributeName range:self.highlightedRange];
    self.messageLabel.attributedText = attributedString;

    self.highlightedRange = NSMakeRange(NSNotFound, 0);
  }
}

#pragma mark - Actions

- (IBAction)followButtonPressed:(id)sender {
  if ([self.delegate respondsToSelector:@selector(reusableView:followAction:)]) {
    [self.delegate reusableView:self followAction:sender];
  }
}

#pragma mark - Size Helpers Methods

+ (CGFloat)feedCellHeightForModel:(APPSUserFeedsModel *)model
                           ofType:(APPSNewsFeedTableViewCellType)cellType {
  CGFloat height = 0.f;
  APPSNewsFeedModel *firstFeedModel = [model firstNewsFeedModel];
  UIFont *messageFont = FONT_HELVETICANEUE_LIGHT(14.f);

  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  paragraphStyle.alignment = NSTextAlignmentLeft;

  NSDictionary *attributes =
      @{NSFontAttributeName : messageFont, NSParagraphStyleAttributeName : paragraphStyle};

  NSMutableString *message = [NSMutableString new];
  [message appendFormat:@"%@ ", model.user.username];

  if (cellType == APPSNewsFeedTableViewCellTypeYours) {
    [message appendFormat:@"%@", [APPSNewsFeedTableViewCell
                                     messageForYoursFeedType:[model.feedType integerValue]]];
  } else {
    [message appendFormat:@"%@", [APPSNewsFeedTableViewCell messageForFollowedFeeds:model]];
  }

  NSString *createdAt =
      [NSString stringWithFormat:CreatedAtFormatString,
                                 [NSDate relativeDateFromString:firstFeedModel.createdAt]];

  CGFloat messageWidth = DefaultLabelWidth;
  CGFloat spacings = 30.f;

  CGFloat bottomWidth = 0.f;

  if ([model.feedType integerValue] == APPSNewsFeedTypeLike) {
    if (model.feeds.count > 1) {
      bottomWidth = PhotoCollectionViewRowWidth * ((model.feeds.count > 5) + 1);
    }
  } else if ([model.feedType integerValue] == APPSNewsFeedTypeComment) {
    bottomWidth = [APPSNewsFeedTableViewCell heightForString:firstFeedModel.message
                                              withAttributes:attributes
                                                       width:DefaultLabelWidth];
  }

  height = [APPSNewsFeedTableViewCell heightForString:message
                                       withAttributes:attributes
                                                width:messageWidth];
  height += [APPSNewsFeedTableViewCell heightForString:createdAt
                                        withAttributes:attributes
                                                 width:messageWidth];
  height += bottomWidth;
  height += spacings;

  return height;
}

+ (CGFloat)heightForString:(NSString *)string
            withAttributes:(NSDictionary *)dictAttr
                     width:(CGFloat)width {
  CGSize size = CGSizeMake(width, INT16_MAX);
  CGSize result = [string boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:dictAttr
                                       context:nil].size;
  return ceil(result.height);
}

#pragma mark - Followed Feeds Message

+ (NSString *)messageForFollowedFeeds:(APPSUserFeedsModel *)userFeeds {
    NSString *message;
    APPSNewsFeedType feedType = [userFeeds.feedType integerValue];
    
    switch (feedType) {
        case APPSNewsFeedTypeLike:
            message = [APPSNewsFeedTableViewCell messageForLikeFeed:userFeeds];
            break;
        case APPSNewsFeedTypeComment:
            message = NSLocalizedString(@"left a comment on the photo", nil);
            break;
        case APPSNewsFeedTypeFollow:
            message = [APPSNewsFeedTableViewCell messageForFollowFeed:userFeeds];
            break;
        default:
            break;
    }
    return message;
}

+ (NSString *)messageForLikeFeed:(APPSUserFeedsModel *)userFeeds {
  NSString *messagePrefix = @"";
  if ([userFeeds hasOneRecepient]) {
    messagePrefix =
        [NSString stringWithFormat:@" of %@", [userFeeds firstNewsFeedModel].recipient.username];
  }

  NSString *message =
      [NSString stringWithFormat:@"liked %ld photo%@%@", (long)userFeeds.feeds.count,
                                 userFeeds.feeds.count > 1 ? @"s" : @"", messagePrefix];

  return message;
}

+ (NSString *)messageForFollowFeed:(APPSUserFeedsModel *)userFeeds {
  NSString *separatorString = userFeeds.feeds.count > 2 ? @", " : @" and ";
  NSMutableString *followMessage =
      [[NSMutableString alloc] initWithString:NSLocalizedString(@"started following ", nil)];

  if (userFeeds.feeds.count > 1) {
    for (APPSNewsFeedModel *feed in userFeeds.feeds) {
      [followMessage appendFormat:@"%@%@", feed.recipient.username, separatorString];
    }
    NSRange range =
        NSMakeRange(followMessage.length - separatorString.length, separatorString.length);
    [followMessage replaceCharactersInRange:range withString:@""];
  } else {
    [followMessage appendFormat:@"%@", [userFeeds firstNewsFeedModel].recipient.username];
  }
  return followMessage;
}

#pragma mark - Yours Feeds Message

+ (NSString *)messageForYoursFeedType:(APPSNewsFeedType)feedType {
    NSString *message;
    switch (feedType) {
        case APPSNewsFeedTypeComment:
            message = NSLocalizedString(@"left a comment on your photo", nil);
            break;
        case APPSNewsFeedTypeLike:
            message = NSLocalizedString(@"liked your photo", nil);
            break;
        case APPSNewsFeedTypeFollow:
            message = NSLocalizedString(@"started following you", nil);
            break;
        case APPSNewsFeedTypeFollowRequest:
            message = NSLocalizedString(@"subscribed you", nil);
            break;
        case APPSNewsFeedTypeDiscovered:
            message = NSLocalizedString(@"just discovered your photo", nil);
            break;
        case APPSNewsFeedTypeInvitePhoto:
            message = NSLocalizedString(@"invited you to a photo", nil);
            break;
        case APPSNewsFeedTypeNearbyInvite:
            message = NSLocalizedString(@"left you a photo nearby", nil);
            break;
        case APPSNewsFeedTypeNearbySurprize:
            message = NSLocalizedString(@"left you a SURPRISE photo nearby", nil);
            break;
    }
    return NSLocalizedString(message, nil);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];

  if (touch.view.tag == LoadPhotoViewTag) {
    if ([self.delegate respondsToSelector:@selector(commentedImageActionInCell:)]) {
      [self.delegate commentedImageActionInCell:self];
    }
  } else if (touch.view.tag == LoadProfileViewTag) {
    if ([self.delegate respondsToSelector:@selector(profileActionInCell:)]) {
      [self.delegate profileActionInCell:self];
    }
  }
  [super touchesBegan:touches withEvent:event];
}

@end
