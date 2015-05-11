//
//  APPSPlacesModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotosModel.h"

@implementation APPSPhotosModel

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"photos" : @"photos",
    @"total_pages" : @"totalPages",
    @"current_page" : @"currentPage",
    @"per_page" : @"perPage"
  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
  return YES;
}

@end
