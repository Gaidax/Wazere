//
//  APPSPaginationModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPaginationModel.h"

@implementation APPSPaginationModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"current_page" : @"currentPage",
    @"per_page" : @"perPage",
    @"total_pages" : @"totalPages"
  }];
}

- (instancetype)initWithCurrentPage:(NSUInteger)currentPage
                            perPage:(NSUInteger)perPage
                         totalPages:(NSUInteger)totalPages {
  self = [super init];
  if (self) {
    _currentPage = currentPage;
    _perPage = perPage;
    _totalPages = totalPages;
  }
  return self;
}

@end
