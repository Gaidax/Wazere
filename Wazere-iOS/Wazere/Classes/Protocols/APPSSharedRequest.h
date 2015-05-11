//
//  SharedRequest.h
//  
//
//  Created by iOS Developer on 2/14/14.
//
//

#import <Foundation/Foundation.h>
#import "APPSCommand.h"

@protocol APPSSharedRequest <APPSCommand>

@property (nonatomic, readonly) NSDictionary *params;
@property (nonatomic, readonly) NSString *keyPath;

@end
