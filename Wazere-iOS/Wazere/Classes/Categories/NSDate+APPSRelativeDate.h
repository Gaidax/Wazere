//
//  NSDate+APPSRelativeDate.h
//  Wazere
//
//  Created by Alexey Kalentyev on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (APPSRelativeDate)

- (NSString *)distanceOfTimeInWordsSinceDate:(NSDate *)aDate;
- (NSString *)distanceOfTimeInWordsToNow;
+ (NSString *)relativeDateFromString:(NSString *)createdAt;

@end
