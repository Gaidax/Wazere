//
//  APPSSearchConstants.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSSearchConstants_h
#define Wazere_APPSSearchConstants_h

static NSString *const kSearchSupplementaryViewIdentifier = @"SearchSegmentControlIdentifier";
static NSString *const kHashtagResultCellIdentifier = @"HashtagResultCellIdentifier";

static NSString *const kFacebookSearchTableViewHeader = @"FacebookSearchTableHeader";
static NSString *const kFacebookSearchCollectionViewCell = @"FacebookSearchCollectionCell";

static NSString *const kFacebookFrindsKeyPath = @"users/%@/facebook_friends";
static NSString *const kSearchKeyPath = @"users/search";
static NSString *const kHashtagKeyPath = @"tags/search";

static CGFloat const SearchCellHeight = 58.f;
static CGFloat const PhotoSearchCellHeight = 140.f;

static CGFloat const SegmentHeaderViewHeight = 50.f;

#endif
