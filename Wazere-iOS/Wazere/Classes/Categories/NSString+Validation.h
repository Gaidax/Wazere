//
//  NSString+Validation.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/2/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

@property(NS_NONATOMIC_IOSONLY, readonly) BOOL apps_isEmailValid;
@property(NS_NONATOMIC_IOSONLY, readonly) BOOL apps_isPasswordValid;
@property(NS_NONATOMIC_IOSONLY, readonly) BOOL apps_isNameValid;

@end
