//
//  APPSAPIUserConstants.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSAPIUserConstants_h
#define Wazere_APPSAPIUserConstants_h

static NSString *const KeyPathUser = @"users";
static NSString *const KeyPathResetPassword = @"users/change_password";
static NSString *const KeyPathFollowUser = @"users/%@/relationships";
static NSString *const KeyPathFollowAllUsers = @"users/%@/relationships/follow_all";

static NSString *const KeyPathFollowingList = @"users/%@/following";
static NSString *const KeyPathFollowersList = @"users/%@/followers";

static NSString *const KeyPathFollowingSearch = @"users/%@/following_search";
static NSString *const KeyPathBadgeReset = @"users/%@/badge_reset";
static NSString *const KeyPathTeaserCheck = @"teaser_check";
static NSString *const kKeyPathForUserComplaint = @"users/%@/complaint";
static NSString *const kKeyPathForUserBlocking = @"block_users/%@.json";

#endif
