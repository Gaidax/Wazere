//
//  APPSBaseRequest.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/1/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSRACSharedRequest.h"

@interface APPSRACBaseRequest : NSObject<APPSRACSharedRequest>

@property(weak, NS_NONATOMIC_IOSONLY) NSURLSessionDataTask *dataTask;

@end

// protected
@interface APPSRACBaseRequest ()

- (id)mapResponse:(id)obj;
- (void)processResponse:(NSHTTPURLResponse *)response;
- (NSMutableURLRequest *)request;
- (NSString *)createURLString;

@end