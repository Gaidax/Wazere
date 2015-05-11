//
//  NSNumber+APPSRealiveNumber.m
//  Wazere
//
//  Created by Alexey Kalentyev on 4/8/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "NSNumber+APPSRealiveNumber.h"

@implementation NSNumber (APPSRealiveNumber)

- (NSString*)suffixNumber {
    
    long long num = [self longLongValue];
    
    NSString* sign = ((num < 0) ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000) {
        return [NSString stringWithFormat:@"%@%lld", sign, num];
    }
    
    NSInteger exp = (NSInteger) (log(num) / log(1000));
    
    NSArray *units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%ld%@",
                                            sign,
                                            (long)(num / pow(1000, exp)),
                                            [units objectAtIndex:(exp-1)]];
}

@end
