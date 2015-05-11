//
//  APPSProfileRectCollectionViewCell.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/9/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileRectCollectionViewCell.h"
#import "APPSResizableLabel.h"
#import "APPSPhotoImageView.h"

@interface APPSProfileRectCollectionViewCell () <PPLabelDelegate>

@end

@implementation APPSProfileRectCollectionViewCell

static NSInteger const touchableViewTag = 10;
static NSInteger const locationSelectedViewTag = 20;
static NSInteger const likesViewTag = 30;

- (void)awakeFromNib {
  UITapGestureRecognizer *tapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(imageDoubleTapRecognized:)];
  tapRecognizer.numberOfTapsRequired = 2;
  [self addGestureRecognizer:tapRecognizer];

  self.moreOptionsButton.layer.borderColor = self.commentButton.layer.borderColor =
    self.likeButton.layer.borderColor = self.watchedCountButton.layer.borderColor = self.likesCountLabel.layer.borderColor =
          [UIColor colorWithRed:0.749 green:0.180 blue:0.196 alpha:1.000].CGColor;
  self.contentView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setMaskTo:self.likeButton byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)];
    [self setMaskTo:self.likesCountLabel byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)];
  self.commentsLabel.delegate = self;
  self.descriptionLabel.delegate = self;
}

#pragma mark PPLabelDelegate

- (BOOL)label:(PPLabel *)label
         didBeginTouch:(UITouch *)touch
    onCharacterAtIndex:(CFIndex)charIndex {
  return YES;
}

- (BOOL)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
  return YES;
}

- (BOOL)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
  if (charIndex != NSNotFound) {
    NSAttributedString *text = label.attributedText;
    if (charIndex < text.length) {
      HotWordType hotWord = [(NSNumber *)[text attribute:kHotWordTypeAttribute
                                                 atIndex:charIndex
                                          effectiveRange:NULL] unsignedIntegerValue];
      NSString *hotWordValue =
          (NSString *)[text attribute:kHotWordValueAttribute atIndex:charIndex effectiveRange:NULL];
      [self processHotWord:hotWordValue withType:hotWord];
    }
  }
  return YES;
}

- (BOOL)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
  return YES;
}

- (void)processHotWord:(NSString *)hotWord withType:(HotWordType)type {
  switch (type) {
    case HotWordTypeUndefined:
      break;
    case HotWordTypeMention:
    case HotWordTypeHashtag:
    case HotWordTypeUsername:
      [self.delegate commentCell:self detectsHotWord:type withText:hotWord];
      break;
    case HotWordTypeViewAllComments:
      [self commentAction:self.commentButton];
      break;
  }
}

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(6.0, 6.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = view.bounds;
    shapeLayer.path = rounded.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:0.749 green:0.180 blue:0.196 alpha:1.000].CGColor;
    shapeLayer.lineWidth = 2;
    [view.layer addSublayer:shapeLayer];
}

#pragma mark - Actions

- (IBAction)likeOrUnlikeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellLikeUnlikeAction:withImageAnimation:)]) {
        [self.delegate cellLikeUnlikeAction:self withImageAnimation:NO];
    }
}

- (IBAction)viewsAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellPhotoViewsAction:)]) {
        [self.delegate cellPhotoViewsAction:self];
    }
}


- (IBAction)commentAction:(id)sender {
  if ([self.delegate respondsToSelector:@selector(cellCommentsPhoto:)]) {
    [self.delegate cellCommentsPhoto:self];
  }
}

- (IBAction)moreOptionsAction:(id)sender {
  if ([self.delegate respondsToSelector:@selector(cellTapsMoreOptions:)]) {
    [self.delegate cellTapsMoreOptions:self];
  }
}

- (void)imageDoubleTapRecognized:(UIGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:self.imageView];
  if ([self.imageView pointInside:location withEvent:nil]) {
    if ([self.delegate respondsToSelector:@selector(cellLikeUnlikeAction:withImageAnimation:)]) {
      [self.delegate cellLikeUnlikeAction:self withImageAnimation:YES];
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];

  if (touch.view.tag == touchableViewTag) {
    if ([self.delegate respondsToSelector:@selector(profileActionInCell:)]) {
      [self.delegate profileActionInCell:self];
    }
  }
    if (touch.view.tag == locationSelectedViewTag) {
    if ([self.delegate respondsToSelector:@selector(locationSelectedInCell:)]) {
      [self.delegate locationSelectedInCell:self];
    }
  }
    if (touch.view.tag == likesViewTag) {
        if ([self.delegate respondsToSelector:@selector(cellPhotoLikesAction:)]) {
            [self.delegate cellPhotoLikesAction:self];
        }
    }

  [super touchesBegan:touches withEvent:event];
}

- (void)layoutSubviews {
  [self.descriptionLabel invalidateIntrinsicContentSize];
  [self.commentsLabel invalidateIntrinsicContentSize];
  [super layoutSubviews];
}

@end
