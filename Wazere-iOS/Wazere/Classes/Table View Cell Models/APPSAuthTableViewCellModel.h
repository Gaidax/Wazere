//
//  APPSAuthTableViewCellModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

static const CGFloat whiteColor = 1.0, alpha = 0.3;

@interface APPSAuthTableViewCellModel : NSObject<NSCoding>

@property(strong, NS_NONATOMIC_IOSONLY) UIColor *textFiledBackgroundColor;
@property(strong, NS_NONATOMIC_IOSONLY) UIImage *leftImage;
@property(strong, NS_NONATOMIC_IOSONLY) NSString *textFieldText;
@property(strong, NS_NONATOMIC_IOSONLY) NSString *textFieldPlaceholder;
@property(assign, NS_NONATOMIC_IOSONLY) UIReturnKeyType returnKeyType;
@property(assign, NS_NONATOMIC_IOSONLY) UIKeyboardType keyboardType;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL secureTextEntry;
@property(assign, NS_NONATOMIC_IOSONLY) BOOL isFieldValid;

@end

@interface APPSAuthTableViewCellModel ()

- (void)validity;

@end