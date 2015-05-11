//
//  APPSCommentViewController.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCommentViewController.h"

#import "APPSCommentTableViewCell.h"
#import "APPSCommentRequest.h"

#import "APPSProfileViewController.h"
#import "APPSProfileViewControllerDelegate.h"
#import "APPSProfileViewControllerConfigurator.h"
#import "APPSProfileSegueState.h"

#import "APPSUser.h"
#import "APPSChannel.h"
#import "NSDate+APPSRelativeDate.h"

static NSString *APPSCommentTableViewCellIdentifier = @"APPSCommentTableViewCell";
static NSString *AutoCompletionCellIdentifier = @"APPSTableViewCell";

static NSString *const kSearchPattern = @"[A-Za-z0-9.-_]+";
static NSString *const kIdentityAttributeName = @"name";

@interface APPSCommentViewController () <SWTableViewCellDelegate, APPSCommentTableViewCellDelegate,
                                         UIGestureRecognizerDelegate>

@property(strong, nonatomic) NSNumber *commentsCount;
@property(nonatomic, strong) NSMutableArray *commentModels;

@property(nonatomic, strong) NSArray *users;
@property(nonatomic, strong) NSArray *channels;

@property(nonatomic, strong) NSArray *searchResult;

@property(strong, NS_NONATOMIC_IOSONLY) UITapGestureRecognizer *keyboardTapRecognizer;

@end

@implementation APPSCommentViewController

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _keyboardTapRecognizer.delegate = nil;
}

- (instancetype)initWithPhotoModel:(APPSPhotoModel *)photoModel {
  self = [super initWithTableViewStyle:UITableViewStylePlain];
  if (self) {
    self.view.backgroundColor = UIColorFromRGB(245, 245, 245, 1.0);
    self.photoModel = photoModel;
    [self loadComments];
    [self loadDataFromDB];
    [self configuratProperties];
    [self configuratNotifications];
  }
  return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.screenName = @"Comments screen";
  [self configurNavigationBar];
  [self configuratCommentTableView];
  [self configuratAutoCompletionTableView];
  [self configuratTextView];
  [self configuratTextInputBar];
  self.keyboardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(triggersKeyboardRecognizer:)];
  self.keyboardTapRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.textView resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - Controller configuration

- (void)configurNavigationBar {
  NSMutableDictionary *attributes = [NSMutableDictionary
      dictionaryWithDictionary:[self.navigationController.navigationBar titleTextAttributes]];
  [attributes setValue:FONT_CHAMPAGNE_LIMOUSINES_BOLD(20) forKey:NSFontAttributeName];
  [attributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
  [self.navigationController.navigationBar setTitleTextAttributes:attributes];
  self.title = NSLocalizedString(@"Comments", nil);
  self.navigationItem.backBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@""
                                       style:UIBarButtonItemStyleBordered
                                      target:nil
                                      action:NULL];
}

- (void)configuratProperties {
  self.bounces = YES;
  self.undoShakingEnabled = YES;
  self.keyboardPanningEnabled = YES;
  self.inverted = YES;
  self.typingIndicatorView.canResignByTouch = YES;
  self.commentModels = [NSMutableArray array];
}

- (void)configuratNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShows:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHides:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(disposeViewControllerNotification:)
                                               name:kMemoryWarningNotificationName
                                             object:nil];
}

- (void)configuratCommentTableView {
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor clearColor];
  [self.tableView registerNib:[UINib nibWithNibName:APPSCommentTableViewCellIdentifier bundle:nil]
       forCellReuseIdentifier:APPSCommentTableViewCellIdentifier];
}

- (void)configuratAutoCompletionTableView {
  [self.autoCompletionView registerClass:[APPSCommentTableViewCell class]
                  forCellReuseIdentifier:AutoCompletionCellIdentifier];
  [self registerPrefixesForAutoCompletion:@[ @"@", @"#" ]];
}

- (void)configuratTextView {
  self.textView.layer.cornerRadius = 0;
  self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.textView.layer.borderWidth = 1;
  self.textView.clipsToBounds = YES;
  self.textView.backgroundColor = [UIColor clearColor];
  self.textView.font = FONT_GOTHIC_(15);
  self.textView.textColor = [UIColor whiteColor];
  self.textView.placeholderLabel.text = NSLocalizedString(@"Add comment ...", nil);
  CGFloat commnetPlaceholderFontSize = 14.0;
  self.textView.placeholderLabel.font = [UIFont systemFontOfSize:commnetPlaceholderFontSize];
  self.textView.placeholderLabel.textColor = [UIColor whiteColor];
}

- (void)configuratTextInputBar {
  self.textInputbar.autoHideRightButton = YES;
  self.textInputbar.backgroundColor = UIColorFromRGB(205, 68, 65, 1.0);
  [self configuratrightButton];
}

- (void)configuratrightButton {
  self.rightButton.titleLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(13);
  [self.rightButton setTitleColor:UIColorFromRGB(205, 68, 65, 1.0) forState:UIControlStateNormal];
  [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
  self.rightButton.backgroundColor = [UIColor whiteColor];
}

#pragma mark Keyboard

- (void)keyboardWillShows:(NSNotification *)notification {
  [self.tableView addGestureRecognizer:self.keyboardTapRecognizer];
}

- (void)keyboardWillHides:(NSNotification *)notification {
  [self.tableView removeGestureRecognizer:self.keyboardTapRecognizer];
}

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
  [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {
  return gestureRecognizer == self.keyboardTapRecognizer ? YES : NO;
}

#pragma mark - Load data

- (void)loadComments {
  NSString *keyPath;
  if (self.commentModels.count) {
    keyPath = [NSString
        stringWithFormat:kPhotoCommentsBeforeKeyPath, (unsigned long)self.photoModel.photoId,
                         (unsigned long)[[self.commentModels lastObject] commentId]];
  } else {
    keyPath =
        [NSString stringWithFormat:kPhotoCommentsKeyPath, (unsigned long)self.photoModel.photoId];
  }
  APPSCommentRequest *request = [[APPSCommentRequest alloc] initWithObject:nil
                                                                    params:nil
                                                                    method:HTTPMethodGET
                                                                   keyPath:keyPath
                                                                disposable:nil];
  @weakify(self);
  [request.execute subscribeNext:^(NSDictionary *dict) {
      @strongify(self);
      if (dict) {
        self.commentsCount = dict[kCommentsCountKey];
        [self.commentModels addObjectsFromArray:dict[kCommentsKey]];
      }
      [self.tableView reloadData];
      [self insertCommentsInPhotoModel];
  } error:^(NSError *error) { NSLog(@"%@", error); }];
}

- (void)loadDataFromDB {
  self.users = [APPSUser MR_findAll];
  self.channels = [APPSChannel MR_findAll];
}

#pragma mark - Action Methods

- (void)editLastMessage:(id)sender {
  NSString *lastMessage = [self.commentModels firstObject];
  [self editText:lastMessage];

  [self.tableView slk_scrollToTopAnimated:YES];
}

- (void)didSaveLastMessageEditing:(id)sender {
  NSString *message = [self.textView.text copy];

  [self.commentModels removeLastObject];
  [self.commentModels addObject:message];

  [self.tableView reloadData];
}

#pragma mark - Overriden Methods

- (void)textWillUpdate {
  [super textWillUpdate];

  // Useful for notifying when user will type some text
}

- (void)textDidUpdate:(BOOL)animated {
  [super textDidUpdate:animated];

  // Useful for notifying when user did type some text
}

- (void)didPressLeftButton:(id)sender {
  [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender {
  // This little trick validates any pending auto-correction or auto-spelling
  // just after hitting the 'Send' button (in iOS7)
  if ([self.textView isFirstResponder]) {
    [self.textView resignFirstResponder];
    [self.textView becomeFirstResponder];
  }

  NSString *message = [self.textView.text copy];
  [self saveDataToDBFromMessage:message];
  [self sendCommentWithMessage:message];

  APPSCommentModel *commentModel = [[APPSCommentModel alloc] init];
  commentModel.message = message;
  APPSCurrentUser *currentUser = [[APPSCurrentUserManager sharedInstance] currentUser];
  NSDictionary *currentUserDict =
      [GRTJSONSerialization JSONDictionaryFromManagedObject:currentUser];
  NSError *error = nil;
  APPSSomeUser *someUser =
      [[APPSSomeUser alloc] initWithDictionary:currentUserDict[@"user"] error:&error];
  commentModel.user = someUser;
  [self.commentModels insertObject:commentModel atIndex:0];

  self.commentsCount = @([self.commentsCount unsignedIntegerValue] + 1);
  [self insertCommentsInPhotoModel];

  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                        withRowAnimation:UITableViewRowAnimationBottom];
  [self.tableView endUpdates];

  [self.tableView slk_scrollToTopAnimated:YES];

  [super didPressRightButton:sender];
}

- (void)insertCommentsInPhotoModel {
  NSUInteger commentsCount = [self.commentsCount unsignedIntegerValue];
  [self insertCommentsInPhotoModelWithCommentsCount:commentsCount];
}

- (void)insertCommentsInPhotoModelWithCommentsCount:(NSUInteger)count {
  NSArray *photoComments = self.commentModels;
  self.photoModel.commentsCount = count;
  if (photoComments == nil) {
    photoComments = @[];
  }
  [self createPhotoCommentsForProfileWithComments:photoComments];
}

- (void)createPhotoCommentsForProfileWithComments:(NSArray *)photoComments {
  NSInteger validCommentsCount = kProfileCommentsCount;
  if (photoComments.count > validCommentsCount) {
    photoComments = [photoComments subarrayWithRange:NSMakeRange(0, validCommentsCount)];
  }
  NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:photoComments.count];
  for (NSInteger i = photoComments.count - 1; i >= 0; i--) {
    [comments addObject:photoComments[i]];
  }
  self.photoModel.comments = (NSArray<APPSCommentModel, Optional> *)[comments copy];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:kUpdatePhotoNotificationName
                    object:self
                  userInfo:@{kUpdatePhotoNotificationKey : self.photoModel}];
}

- (void)saveDataToDBFromMessage:(NSString *)message {
  [self saveMentionsInMessage:message];
  [self saveHashtagsInMessage:message];
  [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
  [self loadDataFromDB];
}

- (void)sendCommentWithMessage:(NSString *)message {
  APPSCommentRequest *request = [[APPSCommentRequest alloc]
      initWithObject:nil
              params:@{
                @"message" : message
              }
              method:HTTPMethodPOST
             keyPath:[NSString stringWithFormat:kPhotoCommentsKeyPath,
                                                (unsigned long)self.photoModel.photoId]
          disposable:nil];
  @weakify(self);
  [request.execute subscribeNext:^(NSDictionary *dict) {
      @strongify(self);
      if (dict) {
        self.commentsCount = dict[kCommentsCountKey];
        self.commentModels = [NSMutableArray arrayWithArray:dict[kCommentsKey]];
      }
      [self.tableView reloadData];
      [self insertCommentsInPhotoModel];
  } error:^(NSError *error) { NSLog(@"Error add comment."); }];
}

- (void)saveMentionsInMessage:(NSString *)message {
  [self processEntitiesForClass:[APPSUser class]
                   withmMessage:message
                        pattern:[NSString stringWithFormat:@"@%@", kSearchPattern]];
}

- (void)saveHashtagsInMessage:(NSString *)message {
  [self processEntitiesForClass:[APPSChannel class]
                   withmMessage:message
                        pattern:[NSString stringWithFormat:@"#%@", kSearchPattern]];
}

- (void)processEntitiesForClass:(Class) class
                   withmMessage:(NSString *)message
                        pattern:(NSString *)pattern {
  NSArray *matches = [self searchMatchesInString:message withPattern:pattern];
  [self insertEntitiesForClass:class withArray:matches];
}

- (void)insertEntitiesForClass : (Class) class withArray : (NSArray *)array {
  for (NSString *keyword in array) {
    NSInteger specialSymbolsLength = 1;
    NSString *name = [keyword substringFromIndex:specialSymbolsLength];
    NSUInteger count =
        [class MR_countOfEntitiesWithPredicate:
                   [NSPredicate predicateWithFormat:@"%K LIKE %@", kIdentityAttributeName, name]];
    if (count == 0) {
      id newObject = [class MR_createEntity];
      [newObject setName:name];
    }
  }
}

- (NSArray *)searchMatchesInString : (NSString *)string withPattern : (NSString *)pattern {
  NSError *error;
  NSRegularExpression *regularExpression =
      [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
  if (regularExpression == nil) {
    NSLog(@"%@", error);
    return nil;
  }
  NSMutableArray *matches = [[NSMutableArray alloc] initWithCapacity:0];
  [regularExpression
      enumerateMatchesInString:string
                       options:0
                         range:NSMakeRange(0, string.length)
                    usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        [matches addObject:[string substringWithRange:result.range]];
                    }];
  return [matches copy];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat bottomEdge = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame);
  if (bottomEdge >= scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)) {
    [self loadComments];
  }
}

- (void)didPasteImage:(UIImage *)image {
  // Useful for sending an image

  NSLog(@"%s", __FUNCTION__);
}

- (void)willRequestUndo {
  [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender {
  NSString *message = [self.textView.text copy];

  [self.commentModels removeObjectAtIndex:0];
  [self.commentModels insertObject:message atIndex:0];
  [self.tableView reloadData];

  [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender {
  [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton {
  return [super canPressRightButton];
}

- (BOOL)canShowAutoCompletion {
  NSArray *array = nil;
  NSString *prefix = self.foundPrefix;
  NSString *word = self.foundWord;

  self.searchResult = nil;

  if ([prefix isEqualToString:@"@"]) {
    array = self.users;

    if (word.length > 0) {
      array =
          [array filteredArrayUsingPredicate:[NSPredicate
                                                 predicateWithFormat:@"self.%K BEGINSWITH[c] %@",
                                                                     kIdentityAttributeName, word]];
    }
  } else if ([prefix isEqualToString:@"#"]) {
    array = self.channels;
    if (word.length > 0) {
      array =
          [array filteredArrayUsingPredicate:[NSPredicate
                                                 predicateWithFormat:@"self.%K BEGINSWITH[c] %@",
                                                                     kIdentityAttributeName, word]];
    }
  }

  if (array.count > 0) {
    array = [array sortedArrayUsingDescriptors:@[
      [NSSortDescriptor sortDescriptorWithKey:kIdentityAttributeName ascending:YES]
    ]];
  }

  self.searchResult = [[NSMutableArray alloc] initWithArray:array];

  return self.searchResult.count > 0;
}

- (CGFloat)heightForAutoCompletionView {
  CGFloat cellHeight =
      [self.autoCompletionView.delegate tableView:self.autoCompletionView
                          heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  return cellHeight * self.searchResult.count;
}

- (NSArray *)keyCommands {
  NSMutableArray *commands = [NSMutableArray arrayWithArray:[super keyCommands]];

  // Edit last message
  [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow
                                          modifierFlags:0
                                                 action:@selector(editLastMessage:)]];

  return commands;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([tableView isEqual:self.tableView]) {
    return self.commentModels.count;
  } else {
    return self.searchResult.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([tableView isEqual:self.tableView]) {
    return [self messageCellForRowAtIndexPath:indexPath];
  } else {
    return [self autoCompletionCellForRowAtIndexPath:indexPath];
  }
}

- (APPSCommentTableViewCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  APPSCommentTableViewCell *cell = (APPSCommentTableViewCell *)
      [self.tableView dequeueReusableCellWithIdentifier:APPSCommentTableViewCellIdentifier];
  cell.cellDelegate = self;

  cell.delegate = self;

  APPSCommentModel *commentModel = self.commentModels[indexPath.row];
  cell.usernameLabel.text = commentModel.user.username;
  cell.userCommentLabel.text = commentModel.message;
  cell.createdAtLabel.text = [NSDate relativeDateFromString:commentModel.createdAt];
  cell.indexPath = indexPath;
  cell.topAligned = YES;

  if (commentModel.isMine) {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    [rightUtilityButtons sw_addUtilityButtonWithColor:UIColorFromRGB(255.f, 255.f, 255.f, .3f)
                                                 icon:IMAGE_WITH_NAME(@"trash_icon")];
    cell.rightUtilityButtons = rightUtilityButtons;
  } else {
    cell.rightUtilityButtons = nil;
  }

  if (cell.needsPlaceholder) {
    cell.needsPlaceholder = NO;
  }

  [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.user.avatar]
                        placeholderImage:IMAGE_WITH_NAME(@"photo_placeholder")
                               completed:^(UIImage *image, NSError *error,
                                           SDImageCacheType cacheType, NSURL *imageURL){

                               }];

  // Cells must inherit the table view's transform
  // This is very important, since the main table view may be inverted
  cell.transform = self.tableView.transform;

  return cell;
}

- (APPSCommentTableViewCell *)autoCompletionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  APPSCommentTableViewCell *cell = (APPSCommentTableViewCell *)
      [self.autoCompletionView dequeueReusableCellWithIdentifier:AutoCompletionCellIdentifier];
  cell.indexPath = indexPath;

  id<APPSHotWord> item = self.searchResult[indexPath.row];

  NSString *name = nil;
  if ([self.foundPrefix isEqualToString:@"#"]) {
    name = [NSString stringWithFormat:@"#%@", [item name]];
  } else if ([self.foundPrefix isEqualToString:@"@"]) {
    name = [NSString stringWithFormat:@"@%@", [item name]];
  }

  cell.textLabel.text = name;
  cell.textLabel.font = [UIFont systemFontOfSize:14.0];
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  cell.textLabel.numberOfLines = 1;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([tableView isEqual:self.tableView]) {
    APPSCommentTableViewCell *cell =
        (APPSCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGSize size = [cell.userCommentLabel
        suggestedFrameSizeToFitEntireStringConstraintedToWidth:kCommentLabelWidth];
    CGFloat height = size.height + kTopCommentLabelMargin + kBottomCommentLabelMargin;
    if (height < kMinimumHeight) {
      height = kMinimumHeight;
    }
    return height;
  } else {
    return kAutocompleteHeight;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if ([tableView isEqual:self.autoCompletionView]) {
    UIView *topView = [UIView new];
    topView.backgroundColor = self.autoCompletionView.separatorColor;
    return topView;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([tableView isEqual:self.autoCompletionView]) {
    return 0.5;
  }
  return 0.0;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([tableView isEqual:self.autoCompletionView]) {
    NSMutableString *item = [[self.searchResult[indexPath.row] name] mutableCopy];

    [self acceptAutoCompletionWithString:item];
  } else if ([tableView isEqual:self.tableView]) {
  }
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell
    didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  switch (index) {
    case 0: {
      NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
      if (cellIndexPath == nil) {
        return;
      }
      APPSCommentModel *commentModel = self.commentModels[cellIndexPath.row];
      if ([commentModel.user.userId unsignedIntegerValue] ==
          [[[[APPSCurrentUserManager sharedInstance] currentUser] userId] unsignedIntegerValue]) {
        APPSCommentRequest *request = [[APPSCommentRequest alloc]
            initWithObject:nil
                    method:HTTPMethodDELETE
                   keyPath:[NSString stringWithFormat:kDeleteCommentKeyPath,
                                                      (unsigned long)self.photoModel.photoId,
                                                      (unsigned long)commentModel.commentId]
                disposable:nil];
        [self executeDeleteRequest:request withCommentModel:commentModel];
      } else {
        [cell hideUtilityButtonsAnimated:YES];
      }
      break;
    }

    default:
      break;
  }
}

- (void)executeDeleteRequest:(APPSRACBaseRequest *)request
            withCommentModel:(APPSCommentModel *)commentModel {
  @weakify(self);
  [request.execute subscribeNext:^(NSDictionary *dict) {
      @strongify(self);
      NSUInteger index = [self indexOfComment:commentModel inArray:self.commentModels];
      if (index != NSNotFound) {
        [self.commentModels removeObjectAtIndex:index];
      }
      if (dict) {
        self.commentsCount = dict[kCommentsCountKey];
      }
      [self insertCommentsInPhotoModel];
      [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                            withRowAnimation:UITableViewRowAnimationLeft];
  } error:^(NSError *error) { NSLog(@"%@\nError delete comment", error); }];
}

- (NSUInteger)indexOfComment:(APPSCommentModel *)comment inArray:(NSArray *)array {
  NSUInteger index = NSNotFound;
  for (NSInteger i = 0; i < array.count; i++) {
    APPSCommentModel *currentComment = (APPSCommentModel *)array[i];
    if (currentComment == comment || currentComment.commentId == comment.commentId) {
      index = i;
      break;
    }
  }
  return index;
}

#pragma mark APPSCommentTableViewCellDelegate

- (void)commentCell:(APPSCommentTableViewCell *)commentCell
     detectsHotWord:(STTweetHotWord)hotWord
           withText:(NSString *)text {
  [[[APPSUtilityFactory sharedInstance] hotWordsUtility]
      detectedTweetHotWord:hotWord
                  withText:text
      navigationController:self.navigationController];
}

- (void)commentCell:(APPSCommentTableViewCell *)commentCell usernameAction:(UIButton *)sender {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:commentCell];
  if (indexPath == nil) {
    return;
  }
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
  APPSProfileViewController *profile =
      [storyboard instantiateViewControllerWithIdentifier:kProfileViewControllerIdentifier];
  profile.configurator = [[APPSProfileViewControllerConfigurator alloc] init];
  APPSProfileViewControllerDelegate *delegate = [[APPSProfileViewControllerDelegate alloc]
      initWithViewController:profile
                        user:[(APPSCommentModel *)self.commentModels[indexPath.row] user]];
  profile.delegate = delegate;
  profile.dataSource = delegate;
  profile.state = [[APPSProfileSegueState alloc] init];
  [self.navigationController pushViewController:profile animated:YES];
}

#pragma mark Memory warning notification

- (void)disposeViewControllerNotification:(NSNotification *)notification {
  if (self.view.window) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
