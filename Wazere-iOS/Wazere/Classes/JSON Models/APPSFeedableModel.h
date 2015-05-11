//
//  APPSFeedableModel.h
//  Wazere
//
//  Created by Gaidax on 10/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@interface APPSFeedableModel : APPSBaseModel

@property(assign, nonatomic) NSInteger feedableId;
@property(strong, nonatomic) NSString<Optional> *photoUrl;
@property(strong, nonatomic) NSString<Optional> *feedableType;
@property(strong, nonatomic) NSString<Optional> *tagline;
@property(assign, nonatomic) BOOL isAllowed;

@end
