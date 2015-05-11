//
//  APPSProfileRectCollectionViewLayout.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/11/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileRectCollectionViewLayout.h"

#define kCellWidth SCREEN_WIDTH
#define kCellHeight (114 + SCREEN_WIDTH)

@interface APPSProfileRectCollectionViewLayout ()

@property(assign, NS_NONATOMIC_IOSONLY) UIEdgeInsets itemInsets;
@property(assign, NS_NONATOMIC_IOSONLY) CGSize itemSize;
@property(assign, NS_NONATOMIC_IOSONLY) CGRect headerRect;

@property(strong, NS_NONATOMIC_IOSONLY) NSMutableArray *cellExtraHeights;

@end

@implementation APPSProfileRectCollectionViewLayout

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setupCellExtraHeights {
  if ([self.delegate respondsToSelector:@selector(cellExtraHeights)]) {
    self.cellExtraHeights = [self.delegate cellExtraHeights];
  }
}

- (void)setupItemInsets {
  self.itemInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

- (void)setupItemSize {
  CGFloat normalWidth = SCREEN_WIDTH;
  CGFloat scale = CGRectGetWidth(self.collectionView.frame) / normalWidth;
  self.itemSize = CGSizeMake(kCellWidth * scale, kCellHeight * scale);
}

- (void)setupHeaderSize {
  CGFloat headerWidth = [[UIScreen mainScreen] bounds].size.width,
          headerHeight = ProfileHeaderViewHeight;
  self.headerRect = CGRectMake(0.f, 0.f, headerWidth, headerHeight);
}

- (void)setup {
  [self setupCellExtraHeights];

  [self setupItemInsets];

  [self setupItemSize];
  [self setupHeaderSize];
}

- (CGSize)collectionViewContentSize {
  NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
  CGFloat extraHeight = 0.f;

  for (NSNumber *height in self.cellExtraHeights) {
    extraHeight += [height doubleValue];
  }

  CGFloat height = self.itemInsets.top + CGRectGetHeight(self.headerRect) +
                   rowCount * self.itemSize.height + extraHeight + self.itemInsets.bottom;
  UIView *background = [self.collectionView viewWithTag:kBackgroundViewTag];
  
  [background setFrame:[[[APPSUtilityFactory sharedInstance] profileBackgroundUtility]
                        frameForBackgroundViewWithHeaderRect:self.headerRect
                        collectioViewRect:self.collectionView.frame
                        contentHeignt:height]];
  return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat previousHeight = 0;

  for (NSUInteger i = 0; i < indexPath.item; i++) {
    previousHeight += [self.cellExtraHeights[i] doubleValue];
  }
  CGFloat originY = floor(self.itemInsets.top + CGRectGetHeight(self.headerRect) + previousHeight +
                          (self.itemSize.height + self.itemInsets.top) * indexPath.item);

  return CGRectMake(self.itemInsets.left, originY, self.itemSize.width,
                    self.itemSize.height + [self.cellExtraHeights[indexPath.item] doubleValue]);
}

@end
