//
//  SearchQueue.m
//  Presentation project
//
//  Created by Petr Yanenko on 9/7/13.
//  Copyright (c) 2013 Petr Yanenko. All rights reserved.
//

#import "APPSSearchQueue.h"

typedef void (^SearchTask)(void);

@interface APPSSearchQueue ()

@property CLGeocoder *geocoder;
@property BOOL busy;
@property NSMutableArray *queueArray;

@end

@implementation APPSSearchQueue

- (id)init {
  self = [super init];
  if (self) {
    self.geocoder = [CLGeocoder new];
    self.queueArray = [NSMutableArray new];
  }
  return self;
}

- (void)queueTask:(SearchTask)task {
  [self.queueArray addObject:[task copy]];
}

- (SearchTask)dequeueTask {
  if (self.queueArray.count > 0) {
    SearchTask task = self.queueArray[0];
    [self.queueArray removeObject:task];
    return task;
  }
  return nil;
}

- (void)geocodeAddressString:(NSString *)string
           completionHandler:(SearchCompletitionHandler)handler {
  SearchTask task = ^() {
      self.busy = YES;
      [self.geocoder
          geocodeAddressString:string
             completionHandler:^(NSArray *placemarks, NSError *error) {
                 if (handler) {
                   handler(placemarks, error);
                 } else {
                   NSLog(@"%@\n",
                         [NSError errorWithDomain:@"APPSSearchQueue"
                                             code:0
                                         userInfo:@{
                                           NSLocalizedFailureReasonErrorKey : @"Handler is NULL"
                                         }]);
                 }
                 self.busy = NO;
                 SearchTask newTask = [self dequeueTask];
                 if (newTask) {
                   newTask();
                 }
             }];
  };
  if (self.busy) {
    [self queueTask:task];
  } else {
    task();
  }
}

@end
