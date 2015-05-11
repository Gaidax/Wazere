//
//  APPSCurrentUserManager.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSCurrentUserManager : NSObject

+ (APPSCurrentUserManager *)sharedInstance;

@property(NS_NONATOMIC_IOSONLY, readonly, strong) APPSCurrentUser *currentUser;

@end
