//
//  APPSEditProfileViewControllerDelegate.m
//  Wazere
//
//  Created by Gaidax on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSEditProfileViewControllerDelegate.h"
#import "APPSStrategyTableViewController.h"
#import "APPSUpdateUserRequest.h"
#import "APPSSignUpModel.h"
#import "APPSMultipartCommand.h"

#import "APPSEditPhotoTableViewCell.h"
#import "APPSEditTextTableViewCell.h"

#import "APPSResizableTextView.h"
#import "NSString+Validation.h"

static NSInteger const usernameTextFieldTag = 1;
static NSInteger const textViewPlaceholderTag = 10;
static CGFloat const placeholderXPosition = 30.0f;
static NSString *const usernamePlaceholder = @"Username";
static NSString *const descriptionPlaceholder = @"Bio/description";

@interface APPSEditProfileViewControllerDelegate () <
    UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    APPSEditPhotoTableViewCellDelegate, UIActionSheetDelegate, UITextViewDelegate>

@property(strong, nonatomic) UIImage *pickedImage;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *userDescription;

@property(assign, nonatomic) NSInteger numberOfShakes;
@property(assign, nonatomic) BOOL backwardsDirection;

@end

@implementation APPSEditProfileViewControllerDelegate
@synthesize parentController = _parentController;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (NSString *)screenName {
  return @"Edit profile";
}

#pragma mark - APPSStrategyTableViewDataSource

- (void)reloadTableViewController:(APPSStrategyTableViewController *__weak)parentController {
  self.parentController = parentController;
  [self.parentController.tableView reloadData];
}

#pragma mark - APPSStrategyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return !indexPath.row ? [self editPhotoCell] : [self textFieldLabelAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.row ? kFollowListCellHeight : EditPhotoTableViewCellHeight;
}

#pragma mark - Cells Configuration

- (APPSEditPhotoTableViewCell *)editPhotoCell {
  APPSEditPhotoTableViewCell *cell = [self.parentController.tableView
      dequeueReusableCellWithIdentifier:kEditPhotoTableViewCell
                           forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  if (self.pickedImage) {
    cell.userImageView.image = self.pickedImage;
  } else {
    APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.avatar]
                          placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")];
  }
  cell.delegate = self;
  return cell;
}

- (APPSEditTextTableViewCell *)textFieldLabelAtIndex:(NSInteger)index {
  APPSEditTextTableViewCell *cell = [self.parentController.tableView
      dequeueReusableCellWithIdentifier:kFollowListTableViewCell
                           forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
  BOOL usernameTextField = index == usernameTextFieldTag;
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
  NSString *username = self.username ? self.username : currentUser.username;
  NSString *description = self.userDescription ? self.userDescription : currentUser.userDescription;

  NSString *titleLabelText = usernameTextField ? username : description;

  UILabel *placeholder = [self textViewPlacehoderForIndex:index];
  if (!titleLabelText.length) {
    [self addPlaceholder:placeholder onTextView:cell.textView];
  }

  cell.textView.text = titleLabelText;
  cell.textView.textColor = [UIColor whiteColor];
  cell.textView.tintColor = [UIColor whiteColor];
  cell.textView.tag = index;
  cell.textView.delegate = self;

  NSString *textFieldImageName = usernameTextField ? @"user_hash_icon" : @"tagline_icon";
  cell.textView.leftImageView.image = [UIImage imageNamed:textFieldImageName];

  return cell;
}

- (NSString *)placeholderForIndex:(NSInteger)index {
  return index == usernameTextFieldTag ? usernamePlaceholder : descriptionPlaceholder;
}

#pragma mark - Handle bar buttons action

- (void)handleDonePressed {
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:usernameTextFieldTag inSection:0];
  APPSEditTextTableViewCell *cell = (APPSEditTextTableViewCell *)
      [self.parentController.tableView cellForRowAtIndexPath:indexPath];
  NSString *username =
      [cell.textView.text isEqualToString:[self placeholderForIndex:usernameTextFieldTag]]
          ? @""
          : cell.textView.text;
  if (![username apps_isNameValid]) {
    [self shakeWrongDataTextField:cell.textView];
    return;
  }

  [self.parentController.view endEditing:YES];

  if ([self userFieldsParams] || [self userImageModelObject]) {
    [self updateUserInfo];
  } else {
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
  }
}

#pragma mark - Photo Capture

- (void)takeNewPhoto {
  [[self selectPhotoActionSheet] showInView:self.parentController.view];
}

- (UIActionSheet *)selectPhotoActionSheet {
  return [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Change Profile Picture", nil)
                                     delegate:self
                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                            otherButtonTitles:NSLocalizedString(@"Take Photo", nil),
                                              NSLocalizedString(@"Choose from Library", nil), nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (actionSheet.cancelButtonIndex != buttonIndex) {
    UIImagePickerControllerSourceType sourceType =
        buttonIndex == 1 ? UIImagePickerControllerSourceTypePhotoLibrary
                         : UIImagePickerControllerSourceTypeCamera;
    [self openImagePickerWithSourceType:sourceType];
  }
}

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = sourceType;
  if (sourceType == UIImagePickerControllerSourceTypeCamera) {
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
  }

  [self.parentController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  self.pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
  [picker dismissViewControllerAnimated:YES
                             completion:^{ [self.parentController.tableView reloadData]; }];
}

#pragma mark - Textview Delegate

- (UILabel *)textViewPlacehoderForIndex:(NSInteger)index {
  UILabel *placeholder = [[UILabel alloc] init];
  placeholder.tag = textViewPlaceholderTag;
  placeholder.text = [self placeholderForIndex:index];
  placeholder.font = FONT_HELVETICANEUE(15.0f);
  placeholder.textColor = [UIColor colorWithRed:0.718 green:0.176 blue:0.184 alpha:1.000];
  placeholder.userInteractionEnabled = YES;
  return placeholder;
}

- (void)addPlaceholder:(UILabel *)placeholder onTextView:(UITextView *)textView {
  [placeholder setTranslatesAutoresizingMaskIntoConstraints:NO];
  [textView addSubview:placeholder];
  [textView sendSubviewToBack:placeholder];
  [textView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[placeholder]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{
                                                                       @"placeholder" : placeholder
                                                                     }]];
  [textView addConstraint:[NSLayoutConstraint constraintWithItem:placeholder
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:textView
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1.0f
                                                        constant:placeholderXPosition]];
}

- (void)textViewDidChange:(UITextView *)textView {
  UILabel *placeholder = (UILabel *)[textView viewWithTag:textViewPlaceholderTag];
  if (textView.text.length == 0) {
    placeholder = placeholder ? placeholder : [self textViewPlacehoderForIndex:textView.tag];
    [self addPlaceholder:placeholder onTextView:textView];
  } else {
    [placeholder removeFromSuperview];
  }
  [textView invalidateIntrinsicContentSize];
  [textView.superview layoutIfNeeded];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  [self.parentController.tableView
      scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:0]
            atScrollPosition:UITableViewScrollPositionMiddle
                    animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  if (textView.text) {
    if (textView.tag == usernameTextFieldTag) {
      self.username = textView.text;
    } else {
      self.userDescription = textView.text;
    }
  }
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  NSInteger maxNumberOfCharacters = 14;
  NSMutableString *textViewText = [NSMutableString stringWithString:textView.text];

  if (textViewText.length) {
    [textViewText replaceCharactersInRange:range withString:text];
  }

  NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
  BOOL isNewline = NO;
  for (NSInteger i = 0; i < text.length; i++) {
    unichar character = [text characterAtIndex:i];
    if ([newlineSet characterIsMember:character]) {
      isNewline = YES;
      [textView resignFirstResponder];
      break;
    }
  }
  NSInteger maxNumberOfLines = 2;
  NSString *originText = textView.text;
  textView.text = textViewText;
  NSLayoutManager *layoutManager = [textView layoutManager];
  NSInteger numberOfLines, index, numberOfGlyphs = [layoutManager numberOfGlyphs];
  NSRange lineRange;
  for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++) {
    [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
    index = NSMaxRange(lineRange);
  }
  textView.text = originText;

  return !isNewline &&
         (textView.tag == usernameTextFieldTag ? textViewText.length < maxNumberOfCharacters
                                               : numberOfLines <= maxNumberOfLines);
}

#pragma mark - Data Loading

- (void)updateUserInfo {
  APPSCurrentUser *user = [[APPSCurrentUserManager sharedInstance] currentUser];

  APPSMultipartCommand *request = [[APPSMultipartCommand alloc]
      initWithObject:[self userImageModelObject]
              params:[self userFieldsParams]
              method:HTTPMethodPUT
             keyPath:[KeyPathUser stringByAppendingFormat:@"/%@.json", user.userId]
           imageName:@"avatar"
          disposable:nil];

  APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:self.parentController.view];
  [spinner startAnimating];
  @weakify(self);
  [request.execute subscribeNext:^(APPSCurrentUser *currentUser) {
      @strongify(self);
      [spinner stopAnimating];
      if (self.pickedImage) {
        [[SDImageCache sharedImageCache] storeImage:self.pickedImage forKey:currentUser.avatar];
      }
      [[NSNotificationCenter defaultCenter] postNotificationName:kReloadProfileNotificationName
                                                          object:self];
      [self.parentController dismissViewControllerAnimated:YES completion:nil];
  } error:^(NSError *error) {
      [spinner stopAnimating];
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Couldn't change information", nil)
                                  message:error.userInfo[kWebAPIErrorResponseKey]
                                 delegate:nil
                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                        otherButtonTitles:nil] show];
  }];
}

- (NSDictionary *)userFieldsParams {
  if (self.username || self.userDescription) {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    if (self.username) {
      [params setValue:[self.username isEqualToString:usernamePlaceholder] ? @"" : self.username
                forKey:@"username"];
    }

    if (self.userDescription) {
      [params setValue:[self.userDescription isEqualToString:descriptionPlaceholder]
                           ? @""
                           : self.userDescription
                forKey:@"description"];
    }

    return [params copy];
  } else {
    return nil;
  }
}

- (APPSMultipartModel *)userImageModelObject {
  if (self.pickedImage) {
    APPSMultipartModel *model = [[APPSMultipartModel alloc] init];
    model.images = @[ self.pickedImage ];
    return model;
  } else {
    return nil;
  }
}

- (void)shakeWrongDataTextField:(UITextView *)textView {
  [UIView animateWithDuration:0.05
      animations:^{
          textView.transform = CGAffineTransformMakeTranslation(5 * self.backwardsDirection, 0);
      }
      completion:^(BOOL finished) {
          if (self.numberOfShakes >= 5) {
            self.numberOfShakes = 0;
            textView.transform = CGAffineTransformIdentity;
            return;
          }
          self.numberOfShakes++;
          self.backwardsDirection = !self.backwardsDirection;
          [self shakeWrongDataTextField:textView];
      }];
}

@end
