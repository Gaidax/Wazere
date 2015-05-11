//
//  APPSHashtagModel.h
//  Wazere
//
//  Created by Gaidax on 11/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@interface APPSHashtagModel : APPSBaseModel

@property(assign, nonatomic) NSInteger hashtagId;
@property(strong, nonatomic) NSString *name;
@property(assign, nonatomic) NSInteger mediaCount;

@end
