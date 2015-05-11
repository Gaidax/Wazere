//
//  APPSGridLayout.m
//  Wazere
//
//  Created by iOS Developer on 11/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSGridLayout.h"

@implementation APPSGridLayout

static CGFloat const kCellWidth = 152.0;
static CGFloat const kCellHeight = 205.0;

static NSString *const APPSPhotoAlbumLayoutPhotoCellKind = @"APPSProfileSquareCollectionViewCell";
static NSString *const APPSPhotoReusableLayoutPhotoCellKind = @"APPSProfileCollectionReusableView";

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setupInitialState {
  self.currentItem = 0;
  self.currentSection = 0;
}

- (void)setupItemValues {
  CGFloat normalWidth = 320.0;
  CGFloat scale = CGRectGetWidth(self.collectionView.frame) / normalWidth;
  CGFloat const inset = 5.0 * scale;
  self.itemInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
  self.itemSize = CGSizeMake(kCellWidth * scale, kCellHeight * scale);
  self.interItemSpacingY = inset;
}

- (void)setupColumnsNumber {
  self.numberOfColumns = 2;
}

- (void)setupHeaderSize {
  CGFloat headerHeight = ProfileHeaderViewHeight, headerWidth = SCREEN_WIDTH;
  self.headerRect = CGRectMake(0.f, 0.f, headerWidth, headerHeight);
}

- (void)setup {
  [self setupInitialState];
  [self setupItemValues];
  [self setupColumnsNumber];
  [self setupHeaderSize];
}

- (void)prepareLayout {
  [self setup];

  NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
  NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
  NSMutableDictionary *reusableViewLayoutInfo = [NSMutableDictionary dictionary];

  NSInteger sectionCount;
  if ([self.collectionView.dataSource
          respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
    sectionCount =
        [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
  } else {
    sectionCount = [self.collectionView numberOfSections];
  }
  [self createLayoutAttributesWithCellLayoutInfo:cellLayoutInfo
                          reusableViewLayoutInfo:reusableViewLayoutInfo
                                    sectionCount:sectionCount];
  newLayoutInfo[APPSPhotoAlbumLayoutPhotoCellKind] = cellLayoutInfo;
  newLayoutInfo[APPSPhotoReusableLayoutPhotoCellKind] = reusableViewLayoutInfo;

  self.layoutInfo = newLayoutInfo;
}

- (void)createLayoutAttributesWithCellLayoutInfo:(NSMutableDictionary *)cellLayoutInfo
                          reusableViewLayoutInfo:(NSMutableDictionary *)reusableViewLayoutInfo
                                    sectionCount:(NSInteger)sectionCount {
  NSIndexPath *indexPath;

  for (NSInteger section = 0; section < sectionCount; section++) {
    NSInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView
                                                  numberOfItemsInSection:section];

    for (NSInteger item = 0; item < itemCount; item++) {
      indexPath = [NSIndexPath indexPathForItem:item inSection:section];

      UICollectionViewLayoutAttributes *itemAttributes =
          [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
      itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];

      cellLayoutInfo[indexPath] = itemAttributes;

      if (indexPath.item == 0) {
        UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes
            layoutAttributesForSupplementaryViewOfKind:APPSPhotoReusableLayoutPhotoCellKind
                                         withIndexPath:indexPath];
        titleAttributes.frame = [self frameForReusableViewAtIndexPath:indexPath];

        reusableViewLayoutInfo[indexPath] = titleAttributes;
      }
    }
  }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.layoutInfo[APPSPhotoAlbumLayoutPhotoCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)
    layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                   atIndexPath:(NSIndexPath *)indexPath {
  return self.layoutInfo[APPSPhotoReusableLayoutPhotoCellKind][indexPath];
}

- (CGSize)collectionViewContentSize {
  NSInteger numberOfItems =
      [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
  NSInteger rowCount = numberOfItems / self.numberOfColumns;
  NSInteger remainder = numberOfItems % self.numberOfColumns;
  if (remainder) {
    rowCount++;
  }
  CGFloat height = self.itemInsets.top + CGRectGetHeight(self.headerRect) +
                   rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
                   self.itemInsets.bottom;

  UIView *background = [self.collectionView viewWithTag:kBackgroundViewTag];

  [background setFrame:[[[APPSUtilityFactory sharedInstance] profileBackgroundUtility]
                           frameForBackgroundViewWithHeaderRect:self.headerRect
                                              collectioViewRect:self.collectionView.frame
                                                  contentHeignt:height]];
  return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];

  [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                       NSDictionary *elementsInfo, BOOL *stop) {
      [elementsInfo
          enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                              UICollectionViewLayoutAttributes *attributes,
                                              BOOL *innerStop) {
              if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
              }
          }];
  }];

  return allAttributes;
}

- (CGRect)frameForReusableViewAtIndexPath:(NSIndexPath *)indexPath {
  return self.headerRect;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger section = indexPath.item / self.numberOfColumns;

  if (section != self.currentSection) {
    self.currentItem = 0;
    self.currentSection = section;
  }

  CGFloat spacingX = self.collectionView.bounds.size.width - self.itemInsets.left -
                     self.itemInsets.right - (self.numberOfColumns * self.itemSize.width);

  if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);

  CGFloat originX =
      floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * self.currentItem);

  CGFloat originY = floor(self.itemInsets.top + CGRectGetHeight(self.headerRect) +
                          (self.itemSize.height + self.interItemSpacingY) * self.currentSection);

  self.currentItem++;

  return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

@end
