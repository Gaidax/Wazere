//
//  APPSCommentTableViewCell.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCommentTableViewCell.h"

@interface APPSCommentTableViewCell ()

@property(strong, NS_NONATOMIC_IOSONLY) NSDictionary *commentAttributes;

@end

@implementation APPSCommentTableViewCell

- (void)awakeFromNib {
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.usernameLabel.font = FONT_GOTHIC_BOLD(13);
  self.createdAtLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(13);
  self.commentAttributes = @{
    NSForegroundColorAttributeName : [UIColor blackColor],
    NSFontAttributeName : FONT_GOTHIC_(14)
  };
  @weakify(self);
  [self.userCommentLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string,
                                             NSString *protocol, NSRange range) {
      @strongify(self);
      [self.cellDelegate commentCell:self detectsHotWord:hotWord withText:string];
  }];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if ([self.userCommentLabel attributes] != self.commentAttributes) {
    [self.userCommentLabel setAttributes:self.commentAttributes hotWord:STTweetHandle];
    [self.userCommentLabel setAttributes:self.commentAttributes hotWord:STTweetHashtag];
    [self.userCommentLabel setAttributes:self.commentAttributes];
    self.userCommentLabel.textSelectable = NO;
  }
}

- (IBAction)usernameAction:(UIButton *)sender {
  [self.cellDelegate commentCell:self usernameAction:sender];
}

@end
