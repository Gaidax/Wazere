//
//  APPSNewsFeedModel.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBaseModel.h"
#import "APPSSomeUser.h"
#import "APPSFeedableModel.h"

// like: 0, comment: 1, follow: 2, follow_request: 3, invite_photo: 4, discovered: 5, nearby_invite: 6, nearby_surprise: 7
typedef NS_ENUM(NSInteger, APPSNewsFeedType) {
    APPSNewsFeedTypeLike,
    APPSNewsFeedTypeComment,
    APPSNewsFeedTypeFollow,
    APPSNewsFeedTypeFollowRequest,
    APPSNewsFeedTypeInvitePhoto,
    APPSNewsFeedTypeDiscovered,
    APPSNewsFeedTypeNearbyInvite,
    APPSNewsFeedTypeNearbySurprize
};

@interface APPSNewsFeedModel : APPSBaseModel

@property(assign, nonatomic) APPSNewsFeedType feedType;
@property(strong, nonatomic) NSString<Optional> *message;
@property(strong, nonatomic) APPSSomeUser *recipient;
@property(strong, nonatomic) APPSFeedableModel<Optional> *feedable;
@property(strong, nonatomic) NSString *createdAt;
@end
