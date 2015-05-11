//
//  APPSSignUpTableFooterView.m
//  Wazere
//
//  Created by Petr Yanenko on 1/19/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSSignUpTableFooterView.h"
#import "APPSResizableLabel.h"

@interface APPSSignUpTableFooterView () <PPLabelDelegate>

@property(weak, NS_NONATOMIC_IOSONLY) UILabel *eulaLabel;
@property(weak, NS_NONATOMIC_IOSONLY) UIView *mainButtonView;

@end

@implementation APPSSignUpTableFooterView

static CGFloat const kEULAOffset = 26.0;
static NSString *const kEULALinkAttributeName = @"EULALinkAttributeName";
static NSString *const kPolicyLink = @"policy";
static NSString *const kTermsLink = @"terms";

- (instancetype)init {
  self = [super init];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    UIView *mainButtonView = [[[NSBundle mainBundle] loadNibNamed:AUTH_TABLE_FOOTER_VIEW
                                                            owner:nil
                                                          options:nil] firstObject];
    [mainButtonView setTranslatesAutoresizingMaskIntoConstraints:NO];
    UILabel *eulaLabel = [self eulaLabel];
    [self addSubview:eulaLabel];
    [self addSubview:mainButtonView];
    NSDictionary *views = NSDictionaryOfVariableBindings(eulaLabel, mainButtonView);
    [self addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:
                                 [NSString stringWithFormat:@"V:|[mainButtonView(%f)][eulaLabel]|",
                                                            CGRectGetHeight(mainButtonView.frame)]
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:
                                 [NSString stringWithFormat:@"H:|-(%f)-[eulaLabel]-(%f)-|",
                                                            kEULAOffset, kEULAOffset]
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainButtonView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    self.eulaLabel = eulaLabel;
    self.mainButtonView = mainButtonView;
  }
  return self;
}

- (void)layoutSubviews {
  CGSize newSize = [self sizeThatFits:self.bounds.size];
  self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), newSize.width,
                          newSize.height);
  [self.eulaLabel invalidateIntrinsicContentSize];
  [super layoutSubviews];
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize eulaInitialSize = CGSizeMake(size.width - kEULAOffset * 2, 0);
  CGSize eulaSize = [self.eulaLabel sizeThatFits:eulaInitialSize];
  CGSize mainButtonSize = [self.mainButtonView sizeThatFits:size];
  return CGSizeMake(size.width, eulaSize.height + mainButtonSize.height);
}

- (UILabel *)eulaLabel {
  APPSResizableLabel *label = [[APPSResizableLabel alloc] init];
  label.delegate = self;
  label.backgroundColor = [UIColor clearColor];
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentJustified;
  [label setContentCompressionResistancePriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisVertical];
  NSString *privacyPolicyString = NSLocalizedString(kPolicyHeader, nil);
  NSString *termsString = NSLocalizedString(kTermsHeader, nil);
  NSString *eulaFormat = NSLocalizedString(@"By tapping the Login button you are indicating that "
                                           @"you have read the %@ and agree to the %@.",
                                           nil);
  NSString *eulaText = [NSString stringWithFormat:eulaFormat, privacyPolicyString, termsString];
  CGFloat eulaFontSize = 11.0;
  NSRange policyRange = [eulaText rangeOfString:privacyPolicyString];
  NSRange termsRange = [eulaText rangeOfString:termsString];
  NSMutableAttributedString *attributedEULA = [[NSMutableAttributedString alloc]
      initWithString:eulaText
          attributes:@{
            NSForegroundColorAttributeName :
                [UIColor colorWithRed:254. / 255 green:192. / 255 blue:192. / 255 alpha:1.0],
            NSFontAttributeName : [UIFont systemFontOfSize:eulaFontSize]
          }];
  NSDictionary *linkAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:eulaFontSize]
  };
  [attributedEULA addAttributes:linkAttributes range:policyRange];
  [attributedEULA addAttribute:kEULALinkAttributeName value:kPolicyLink range:policyRange];
  [attributedEULA addAttributes:linkAttributes range:termsRange];
  [attributedEULA addAttribute:kEULALinkAttributeName value:kTermsLink range:termsRange];
  label.attributedText = [attributedEULA copy];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
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
      NSString *linkType =
          [text attribute:kEULALinkAttributeName atIndex:charIndex effectiveRange:NULL];
      if ([linkType isEqualToString:kPolicyLink]) {
        self.eulaLink = kPolicyAddress;
      } else if ([linkType isEqualToString:kTermsLink]) {
        self.eulaLink = kTermsAddress;
      } else {
        self.eulaLink = nil;
      }
    }
  }
  return YES;
}

- (BOOL)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
  return YES;
}

@end
