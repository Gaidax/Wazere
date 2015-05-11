//
//  APPSPinModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/23/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPhotoModel.h"

@protocol APPSPinModel
@end

@interface APPSPinModel : JSONModel

@property(assign, nonatomic) NSUInteger pinId;
@property(assign, nonatomic) CGFloat latitude;
@property(assign, nonatomic) CGFloat longitude;
@property(assign, nonatomic) CGFloat radius;
@property(strong, nonatomic) NSDate *createdAt;
@property(strong, nonatomic) NSDate *updatedAt;

@property(strong, nonatomic) NSArray<APPSPhotoModel, Ignore> *photos;

- (instancetype)initWithPhoto:(APPSPhotoModel *)photo NS_DESIGNATED_INITIALIZER;

@end
