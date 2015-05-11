//
//  APPSSharePhotoTableViewCell.m
//  Wazere
//
//  Created by iOS Developer on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoHeader.h"
#import "APPSSharePhotoModel.h"
#import "APPSSharePhotoTextField.h"

#define FacebookColor [UIColor colorWithRed:0.178 green:0.268 blue:0.525 alpha:1.000]
#define TwitterColor [UIColor colorWithRed:0.275 green:0.604 blue:0.915 alpha:1.000]

@interface APPSSharePhotoHeader () <UITextViewDelegate, UITextFieldDelegate>

@property(strong, nonatomic) UILabel *textViewPlaceholder;
@property(strong, nonatomic) CLGeocoder *geocoder;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *socialButtonsHeightConstraint;

@end

@implementation APPSSharePhotoHeader

static NSInteger const touchableViewTag = 10;
static CGFloat const kDdescriptionViewFontSize = 14.0f;

- (void)awakeFromNib {
  // Initialization code
  self.bindLocationSwitch.tintColor = [UIColor whiteColor];
  self.bindLocationSwitch.onTintColor = kMainBackgroundColor;
  [self.locationAlias configureTextFiledwithLeftImageName:@"description_icon"];

  self.descriptionView.font = FONT_CHAMPAGNE_LIMOUSINES(kDdescriptionViewFontSize);
  self.textViewPlaceholder = [self createTextViewPlacehoder];
  [self addPlaceholderOnDescriptionView];

  self.geocoder = [[CLGeocoder alloc] init];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleTwitterAuthorizeCallback:)
                                               name:photoUploadingFinishedNotification
                                             object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(APPSSharePhotoModel *)model {
  _model = model;
  self.photo.image = [model.images firstObject];
  model.locationName = nil;
  self.locationAlias.text = nil;
  if (model.location && model.hideLocation == NO) {
    @weakify(self);
    [self.geocoder reverseGeocodeLocation:model.location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                          @strongify(self);
                          if (placemarks == nil) {
                            NSLog(@"%@", error);
                          } else if ([placemarks count] > 0) {
                            self.locationAlias.text = [(CLPlacemark *)placemarks[0] name];
                            self.model.locationName = self.locationAlias.text;
                          }
                        }];
  }
}

- (void)addPlaceholderOnDescriptionView {
  [self.textViewPlaceholder setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.descriptionView addSubview:self.textViewPlaceholder];
  [self.descriptionView sendSubviewToBack:self.textViewPlaceholder];
  [self.descriptionView
      addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"V:|-(8)-[placeholder]"
                                             options:0
                                             metrics:nil
                                               views:@{
                                                 @"placeholder" : self.textViewPlaceholder
                                               }]];
  [self.descriptionView
      addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|-(4)-[placeholder]"
                                             options:0
                                             metrics:nil
                                               views:@{
                                                 @"placeholder" : self.textViewPlaceholder
                                               }]];
}

- (UILabel *)createTextViewPlacehoder {
  UILabel *placeholder = [[UILabel alloc] init];
  placeholder.text = NSLocalizedString(@"Description", nil);
  placeholder.font = FONT_HELVETICANEUE_LIGHT(kDdescriptionViewFontSize);
  placeholder.textColor = [UIColor colorWithRed:0.306 green:0.298 blue:0.298 alpha:1.000];
  placeholder.userInteractionEnabled = YES;
  return placeholder;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
  return string.length <= kMaxDescriptionLength;
}

- (void)textViewDidChange:(UITextView *)textView {
  if (textView.text.length == 0) {
    [self addPlaceholderOnDescriptionView];
  } else {
    [self.textViewPlaceholder removeFromSuperview];
  }
  self.model.photoDescription = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  if (textView.text.length == 0) {
    [self addPlaceholderOnDescriptionView];
  } else {
    [self.textViewPlaceholder removeFromSuperview];
  }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if (textField == self.locationAlias) {
    self.model.locationName =
        [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.model.locationName.length == 0) {
      self.model.locationName = self.locationAlias.text;
    }
  }
  return YES;
}

#pragma mark - Actions

- (IBAction)bindLocationAction:(UISwitch *)sender {
  [self.delegate changeShareLocationStatus:sender.on];
  if (sender.on) {
    self.selectLocationView.backgroundColor =
    self.locationAlias.backgroundColor = [UIColor whiteColor];
  } else {
    self.selectLocationView.backgroundColor =
    self.locationAlias.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
  }
}

- (IBAction)tapsFacebookButton:(UIButton *)sender {
  FBSession *session = [FBSession activeSession];
  if (session.isOpen) {
    [self selectButton:sender usingColor:FacebookColor];
    self.model.shareToFacebook = sender.selected;
  } else {
    @weakify(self);
    [[[APPSUtilityFactory sharedInstance] facebookUtility]
        openSessionWithHandler:^(NSString *token, NSError *error) {
          @strongify(self);
          if (token) {
            [self selectButton:sender usingColor:FacebookColor];
            self.model.shareToFacebook = sender.selected;
          }
        }];
  }
}

- (IBAction)tapsTwitterButton:(UIButton *)sender {
  APPSTwitterUtility *twitter = [[APPSUtilityFactory sharedInstance] twitterUtility];
  if (![twitter isAuthorized]) {
    [twitter authorizeCurrentUser];
  }
  [self selectButton:sender usingColor:TwitterColor];
  self.model.shareToTwitter = sender.selected;
}

- (void)selectButton:(UIButton *)button usingColor:(UIColor *)color {
  button.selected = !button.selected;
  if (button.selected) {
    button.backgroundColor = color;
  } else {
    button.backgroundColor = [UIColor whiteColor];
  }
}

- (void)handleTwitterAuthorizeCallback:(NSNotification *)notification {
  BOOL isAuthorized = [notification.object boolValue];
  if (!isAuthorized) {
    self.twitterButton.selected = NO;
    self.model.shareToTwitter = NO;
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];

  if (touch.view.tag == touchableViewTag) {
    if ([self.delegate respondsToSelector:@selector(chooseNewLocationViewTouched)]) {
      [self.delegate chooseNewLocationViewTouched];
    }
  }
}

@end
