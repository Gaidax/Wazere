//
//  APPSNotificationModel.h
//  Wazere
//
//  Created by Gaidax on 11/7/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"

@interface APPSNotificationModel : APPSBaseModel
@property(strong, nonatomic) NSDictionary *additionalParams;
@property(strong, nonatomic) NSNumber<Optional> *photoId;
@property(strong, nonatomic) NSArray<Optional> *photosIds;
@property(strong, nonatomic) NSNumber<Optional> *userId;
@property(strong, nonatomic) NSString *type;

- (BOOL)shouldLoadPhoto;
@end
