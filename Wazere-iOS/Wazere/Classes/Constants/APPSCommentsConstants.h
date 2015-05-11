//
//  APPSCommentsConstants.h
//  Wazere
//
//  Created by iOS Developer on 10/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSCommentsConstants_h
#define Wazere_APPSCommentsConstants_h

static NSString *const kPhotoCommentsKeyPath = @"photos/%lu/comments";
static NSString *const kPhotoCommentsBeforeKeyPath = @"photos/%lu/comments/before/%lu";
static NSString *const kDeleteCommentKeyPath = @"photos/%lu/comments/%lu";
static NSString *const kFindUserKeyPath = @"users/find/%@";
static NSString *const kMediaKeyPath = @"tags/%@/media";

static NSString *const kCommentsKey = @"commentModels";
static NSString *const kCommentsCountKey = @"commentsCount";

#endif
