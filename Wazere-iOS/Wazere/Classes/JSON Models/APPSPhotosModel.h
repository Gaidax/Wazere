//
//  APPSPlacesModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotoModel.h"

@interface APPSPhotosModel : JSONModel

@property(assign, nonatomic) NSInteger totalPages;
@property(assign, nonatomic) NSInteger currentPage;
@property(assign, nonatomic) NSInteger perPage;

@property(strong, nonatomic) NSArray<APPSPhotoModel> *photos;

@end
