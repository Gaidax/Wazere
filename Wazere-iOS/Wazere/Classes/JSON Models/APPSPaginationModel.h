//
//  APPSPaginationModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/18/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "JSONModel.h"

@interface APPSPaginationModel : JSONModel

@property(assign, nonatomic) NSUInteger currentPage;
@property(assign, nonatomic) NSUInteger perPage;
@property(assign, nonatomic) NSUInteger totalPages;

- (instancetype)initWithCurrentPage:(NSUInteger)currentPage
                            perPage:(NSUInteger)perPage
                         totalPages:(NSUInteger)totalPages NS_DESIGNATED_INITIALIZER;

@end
