//
//  SharedRequest.h
//
//
//  Created by iOS Developer on 2/14/14.
//
//

#import <Foundation/Foundation.h>
#import "APPSRACCommand.h"

@protocol APPSRACSharedRequest<APPSRACCommand>

@property(nonatomic, readonly) NSString *method;
@property(nonatomic, readonly) NSDictionary *params;
@property(nonatomic, readonly) NSString *keyPath;

- (instancetype)initWithObject:(id)object
                        params:(NSDictionary *)params
                        method:(NSString *)method
                       keyPath:(NSString *)keyPath
                    disposable:(RACDisposable *)disposable;
- (instancetype)initWithObject:(id)object
                        method:(NSString *)method
                       keyPath:(NSString *)keyPath
                    disposable:(RACDisposable *)disposable;

@end
