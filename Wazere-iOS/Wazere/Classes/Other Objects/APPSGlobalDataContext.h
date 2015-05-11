//
//  GlobalDataContext.h
//  flocknest
//
//  Created by iOS Developer on 12/27/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSGlobalDataContext : NSObject

+ (APPSGlobalDataContext *)getInstance;

- (void)initializeWithLaunchOptions:(NSDictionary *)launchOptions;

@end
