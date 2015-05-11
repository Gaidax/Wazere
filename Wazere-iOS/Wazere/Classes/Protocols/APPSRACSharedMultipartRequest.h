//
//  APPSSharedMultipartRequest.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSRACSharedRequest.h"

@class APPSMultipartModel;

@protocol APPSRACSharedMultipartRequest<APPSRACCommand>

@property(nonatomic, readonly) NSArray *images;
@property(nonatomic, readonly) NSString *imageName;

- (instancetype)initWithObject:(APPSMultipartModel *)object
                        params:(NSDictionary *)params
                        method:(NSString *)method
                       keyPath:(NSString *)keyPath
                     imageName:(NSString *)imageName
                    disposable:(RACDisposable *)disposable;

@end
