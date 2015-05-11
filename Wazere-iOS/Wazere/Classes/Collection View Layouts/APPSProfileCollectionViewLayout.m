//
//  APPSProfileCollectionViewLayout.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/30/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSProfileCollectionViewLayout.h"

#define kCellWidth SCREEN_WIDTH
static CGFloat const kMinCellHeight = 147;

static NSString *const APPSPhotoAlbumLayoutPhotoCellKind = @"APPSProfileSquareCollectionViewCell";
static NSString *const APPSPhotoReusableLayoutPhotoCellKind = @"APPSProfileCollectionReusableView";

@implementation APPSProfileCollectionViewLayout

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

- (void)setupItemValues {
  self.itemInsets = UIEdgeInsetsZero;
  self.itemSize = CGSizeMake(kCellWidth, [self cellHeight]);
}

- (CGFloat)cellHeight {
    CGFloat freeSpaceHeight = CGRectGetHeight(self.collectionView.frame) - [self headerHeight];
    
    return MAX(freeSpaceHeight, [self minimumCellHeight]);
}

- (void)setupHeaderHeight {
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  self.headerRect = CGRectMake(0.f, 0.f, screenSize.width, [self headerHeight]);
}

- (CGFloat)headerHeight {
    return ProfileHeaderViewHeight;
}

- (CGFloat)minimumCellHeight {
    return kMinCellHeight;
}

- (void)setup {
  [self setupItemValues];
  [self setupHeaderHeight];
}

- (void)prepareLayout {
  [self setup];

  NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
  NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
  NSMutableDictionary *reusableViewLayoutInfo = [NSMutableDictionary dictionary];

  NSInteger sectionCount = [self sectionCount];

  NSIndexPath *indexPath;

  for (NSInteger section = 0; section < sectionCount; section++) {
    NSInteger itemCount = [self itemCountInSection:sectionCount];

    for (NSInteger item = 0; item < itemCount; item++) {
      indexPath = [NSIndexPath indexPathForItem:item inSection:section];
      [self addItemAttributesWithCellLayoutInfo:cellLayoutInfo
                         reusableViewLayoutInfo:reusableViewLayoutInfo
                                      indexPath:indexPath];
    }
  }

  newLayoutInfo[APPSPhotoAlbumLayoutPhotoCellKind] = cellLayoutInfo;
  newLayoutInfo[APPSPhotoReusableLayoutPhotoCellKind] = reusableViewLayoutInfo;

  self.layoutInfo = newLayoutInfo;
}

- (NSInteger)sectionCount {
  NSInteger sectionCount;
  if ([self.collectionView.dataSource
          respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
    sectionCount =
        [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
  } else {
    sectionCount = [self.collectionView numberOfSections];
  }
  return sectionCount;
}

- (NSInteger)itemCountInSection:(NSInteger)section {
  return [self.collectionView.dataSource collectionView:self.collectionView
                                 numberOfItemsInSection:section];
}

- (void)addItemAttributesWithCellLayoutInfo:(NSMutableDictionary *)cellLayoutInfo
                     reusableViewLayoutInfo:(NSMutableDictionary *)reusableViewLayoutInfo
                                  indexPath:(NSIndexPath *)indexPath {
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

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.layoutInfo[APPSPhotoAlbumLayoutPhotoCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)
    layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                   atIndexPath:(NSIndexPath *)indexPath {
  return self.layoutInfo[APPSPhotoReusableLayoutPhotoCellKind][indexPath];
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

- (CGSize)collectionViewContentSize {
  NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];

  CGFloat height = self.itemInsets.top + CGRectGetHeight(self.headerRect) +
                   rowCount * self.itemSize.height + (rowCount - 1) * 10 + self.itemInsets.bottom;
  [[self.collectionView viewWithTag:kBackgroundViewTag] setFrame:CGRectZero];
  return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (CGRect)frameForReusableViewAtIndexPath:(NSIndexPath *)indexPath {
  return self.headerRect;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat originY = floor(self.itemInsets.top + CGRectGetHeight(self.headerRect));

  return CGRectMake(self.itemInsets.left, originY, self.itemSize.width, self.itemSize.height);
}

@end
