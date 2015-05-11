//
//  APPSUserFeedsModel.h
//  Wazere
//
//  Created by Gaidax on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"
#import "APPSSomeUser.h"
#import "APPSNewsFeedModel.h"

@interface APPSUserFeedsModel : APPSBaseModel

@property(strong, nonatomic) NSArray *feeds;
@property(strong, nonatomic) APPSSomeUser *user;
@property(assign, nonatomic) NSNumber<Optional> *feedType;

- (BOOL)shouldShowImages;
- (BOOL)hasOneRecepient;

- (APPSNewsFeedModel *)firstNewsFeedModel;
@end
