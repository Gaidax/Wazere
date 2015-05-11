//
//  SharedMultipartRequest.h
//  flocknest
//
//  Created by Ostap on 3/4/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPSObjectSharedRequest.h"

@protocol APPSSharedMultipartRequest <APPSSharedObjectRequest>

@property (readonly) RKRequestMethod requestMethod;

-(void)setFileData:(NSArray *)datas keyName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
