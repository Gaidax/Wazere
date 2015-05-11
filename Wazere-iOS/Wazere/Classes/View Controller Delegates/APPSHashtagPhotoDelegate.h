//
//  APPSHashtagPhotoDelegate.h
//  Wazere
//
//  Created by iOS Developer on 11/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapPhotosDelegate.h"

@interface APPSHashtagPhotoDelegate : APPSMapPhotosDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController
                                  user:(id<APPSUserProtocol>)user
                               hashtag:(NSString *)hashtag;

@end
