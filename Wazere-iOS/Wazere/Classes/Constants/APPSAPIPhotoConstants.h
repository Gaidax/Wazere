//
//  APPSAPIPhotoConstants.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSAPIPhotoConstants_h
#define Wazere_APPSAPIPhotoConstants_h

static NSString *const KeyPathUserPhotos = @"users/%@/photos";
static NSString *const KeyPathPhotoLikes = @"photos/%lu/likes";
static NSString *const KeyPathHomePhotos = @"users/%@/photos/home/%@";
static NSString *const KeyPathShowPhoto = @"photos/%lu";
static NSString *const kDestroyPhotoKeyPath = @"photos/%lu";
static NSString *const kLikedPhotosKeyPath = @"users/%lu/photos/liked";
static NSString *const kHashtagPhotosKeyPath = @"tags/%@/media";
static NSString *const kPhotoComplaintKeyPath = @"photos/%lu/complaint";

static NSString *const KeyPathLikedUsersList = @"photos/%lu/likes";
static NSString *const KeyPathViewedUsersList = @"photos/%lu/watchers";

#endif
