//
//  APPSUser.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/29/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

@protocol APPSUserProtocol<NSObject, Optional>

@property(strong, nonatomic) NSNumber *userId;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString<Optional> *avatar;
@property(strong, nonatomic) NSString<Optional> *userDescription;
@property(strong, nonatomic) NSString<Optional> *email;
@property(strong, nonatomic) NSNumber<Optional> *photosCount;
@property(strong, nonatomic) NSNumber<Optional> *followersCount;
@property(strong, nonatomic) NSNumber<Optional> *followingCount;
@property(strong, nonatomic) NSNumber<Optional> *likesCount;
@property(strong, nonatomic) NSNumber<Optional> *viewsCount;
@property(strong, nonatomic) NSURL<Optional> *website;

@end
