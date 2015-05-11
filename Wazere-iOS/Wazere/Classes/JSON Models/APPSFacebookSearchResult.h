//
//  APPSFacebookSearchResult.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@interface APPSFacebookSearchResult : APPSBaseModel
@property(strong, nonatomic) NSString<Optional> *avatarUrl;
@property(strong, nonatomic) NSString<Optional> *facebookName;
@property(strong, nonatomic) NSNumber *userId;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSArray<Optional> *photos;
@end
