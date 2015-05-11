//
//  SearchQueue.h
//  Presentation project
//
//  Created by Petr Yanenko on 9/7/13.
//  Copyright (c) 2013 Petr Yanenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchCompletitionHandler)(NSArray *placemarks, NSError *error);

@interface APPSSearchQueue : NSObject

- (void)geocodeAddressString:(NSString *)string
           completionHandler:(SearchCompletitionHandler)handler;

@end