//
//  APPSCommentModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "JSONModel.h"
#import "APPSSomeUser.h"

@protocol APPSCommentModel
@end

@interface APPSCommentModel : JSONModel

@property(assign, nonatomic) NSUInteger commentId;
@property(assign, nonatomic) BOOL isMine;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSString *createdAt;
@property(strong, nonatomic) APPSSomeUser *user;

@end
