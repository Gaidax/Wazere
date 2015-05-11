//
//  ObjectSharedRequest.h
//  
//
//  Created by iOS Developer on 2/14/14.
//
//

#import <Foundation/Foundation.h>
#import "APPSSharedRequest.h"

@protocol APPSSharedObjectRequest <APPSSharedRequest>

@property (nonatomic, readonly) id requestObject;

@end
