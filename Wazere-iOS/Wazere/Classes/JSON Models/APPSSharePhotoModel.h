//
//  APPSSharePhotoModel.h
//  Wazere
//
//  Created by iOS Developer on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMultipartModel.h"

@class APPSSharePhotoDelegate;

@interface APPSSharePhotoModel : APPSMultipartModel

@property(assign, nonatomic) BOOL isPublic;
@property(assign, nonatomic) BOOL shareToFacebook;
@property(assign, nonatomic) BOOL shareToTwitter;
@property(strong, nonatomic) NSString *locationName;
@property(strong, nonatomic) NSArray *friendIds;
@property(assign, nonatomic) CLLocationDegrees latitude;
@property(assign, nonatomic) CLLocationDegrees longitude;
@property(assign, nonatomic) BOOL hideLocation;

@end

// RAC
@interface APPSSharePhotoModel ()

@property(strong, nonatomic) NSString *tagline;
@property(assign, nonatomic) BOOL isSurprise;
@property(strong, nonatomic) NSString *photoDescription;
@property(strong, nonatomic) CLLocation<Ignore> *location;

@end
