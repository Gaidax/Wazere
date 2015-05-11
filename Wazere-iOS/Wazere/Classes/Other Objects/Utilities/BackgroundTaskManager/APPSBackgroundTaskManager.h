//
//  BackgroundTaskManager.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSBackgroundTaskManager : NSObject

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;
- (void)endAllBackgroundTasks;

@end
