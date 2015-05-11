//
//  APPSCurrentUser.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "APPSUserProtocol.h"

@interface APPSCurrentUser : NSManagedObject<APPSUserProtocol>

@property(assign, nonatomic) BOOL newUser;
@property(assign, nonatomic) BOOL showFacebookFriends;
@property(retain, nonatomic) NSString *facebookName;

@end
