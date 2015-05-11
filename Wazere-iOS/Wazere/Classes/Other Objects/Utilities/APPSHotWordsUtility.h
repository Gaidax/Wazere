//
//  APPSHotWordsUtility.h
//  Wazere
//
//  Created by iOS Developer on 11/13/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSProfileConstants.h"

@interface APPSHotWordsUtility : NSObject

- (void)detectedHotWord:(HotWordType)hotWord
                withText:(NSString *)text
    navigationController:(UINavigationController *)navController;
- (void)detectedTweetHotWord:(STTweetHotWord)hotWord
                    withText:(NSString *)text
        navigationController:(UINavigationController *)navController;
- (void)openProfileWithUser:(id<APPSUserProtocol>)user
       navigationController:(UINavigationController *)navController;

@end
