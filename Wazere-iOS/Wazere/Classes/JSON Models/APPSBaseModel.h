//
//  APPSBaseModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "JSONModel.h"
#import <JSONModel/JSONAPI.h>

@interface APPSBaseModel : JSONModel

@property(NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *serializable;
- (instancetype)deserializable:(NSDictionary *)params;

@end

@interface APPSBaseModel ()

@end