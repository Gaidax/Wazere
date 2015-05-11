//
//  Command.h
//  Command
//
//  Created by User on 12.02.14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPSRACCommand<NSObject>

@property(nonatomic, readonly) RACDisposable *disposable;

- (RACSignal *)execute;
- (void)cancel;

@end
