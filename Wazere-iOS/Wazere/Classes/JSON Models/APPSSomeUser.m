//
//  APPSSomeUser.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSomeUser.h"

@implementation APPSSomeUser

@synthesize userId = _userId;
@synthesize username = username;
@synthesize avatar = avatar;
@synthesize userDescription = userDescription;
@synthesize email = email;
@synthesize photosCount = photosCount;
@synthesize followersCount = followersCount;
@synthesize followingCount = followingCount;
@synthesize website = website;
@synthesize banned = banned;
@synthesize likesCount = likesCount;
@synthesize viewsCount = viewsCount;

+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
    @"id" : @"userId",
    @"username" : @"username",
    @"avatar_url" : @"avatar",
    @"email" : @"email",
    @"description" : @"userDescription",
    @"photos_count" : @"photosCount",
    @"followed_counter" : @"followingCount",
    @"follower_counter" : @"followersCount",
    @"total_likes_count" : @"likesCount",
    @"total_views_count" : @"viewsCount",
    @"website" : @"website",
    @"is_followed" : @"isFollowed",
    @"banned" : @"banned",
    @"is_blocked" : @"isBlocked",
  }];
}

@end
