//
//  APPSSomeUser.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "JSONModel.h"
#import "APPSUserProtocol.h"

@protocol APPSSomeUser
@end

@interface APPSSomeUser : JSONModel<APPSUserProtocol>

@property(strong, nonatomic) NSNumber<Optional> *isFollowed;
@property(strong, nonatomic) NSNumber<Optional> *banned;
@property(strong, nonatomic) NSNumber<Optional> *isBlocked;

@end
