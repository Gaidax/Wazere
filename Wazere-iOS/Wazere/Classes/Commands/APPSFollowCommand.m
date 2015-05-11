//
//  APPSFollowCommand.m
//  Wazere
//
//  Created by Gaidax on 12/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFollowCommand.h"

@implementation APPSFollowCommand

- (NSDictionary *)mapResponse:(NSDictionary *)obj {
    NSError *error;
    
    [GRTJSONSerialization mergeObjectForEntityName:NSStringFromClass([APPSCurrentUser class])
                                fromJSONDictionary:obj
                            inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                             error:&error];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return obj;
}

@end
