//
//  BackgroundTaskManager.m
//  Wazere
//
//  Created by Gaidax on 10/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSBackgroundTaskManager.h"

@interface APPSBackgroundTaskManager ()
@property(strong, nonatomic) NSMutableArray* backgroundTasksIds;
@property(assign, nonatomic) UIBackgroundTaskIdentifier masterTaskId;
@end

@implementation APPSBackgroundTaskManager

- (NSMutableArray *)backgroundTasksIds {
    if (!_backgroundTasksIds) {
        _backgroundTasksIds = [NSMutableArray array];
        _masterTaskId = UIBackgroundTaskInvalid;
    }
    return _backgroundTasksIds;
}

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask {
    UIApplication* application = [UIApplication sharedApplication];
    
    UIBackgroundTaskIdentifier backgorundTaskId = UIBackgroundTaskInvalid;
    if ([application respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]) {
        backgorundTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"background task %lu expired", (unsigned long)backgorundTaskId);
        }];
        if (self.masterTaskId == UIBackgroundTaskInvalid) {
            self.masterTaskId = backgorundTaskId;
        } else {
            [self.backgroundTasksIds addObject:@(backgorundTaskId)];
            [self endBackgroundTasks];
        }
    }
    
    return backgorundTaskId;
}

- (void)endBackgroundTasks {
    [self drainBackgroundTaskList:NO];
}

- (void)endAllBackgroundTasks {
    [self drainBackgroundTaskList:YES];
}

- (void)drainBackgroundTaskList:(BOOL)all {
    UIApplication* application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(endBackgroundTask:)]) {
        NSUInteger count = self.backgroundTasksIds.count;
        for (NSUInteger i = (all ? 0 : 1); i < count; i++) {
            UIBackgroundTaskIdentifier bgTaskId = [[self.backgroundTasksIds objectAtIndex:0] integerValue];
            [application endBackgroundTask:bgTaskId];
            [self.backgroundTasksIds removeObjectAtIndex:0];
        }
    }
}

@end
