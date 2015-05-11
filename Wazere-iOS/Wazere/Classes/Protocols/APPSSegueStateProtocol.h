//
//  SegueStateProtocol.h
//  flocknest
//
//  Created by Petr Yanenko on 2/23/14.
//  Copyright (c) 2014 Rost K. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPSSegueStateProtocol<NSObject, NSCoding>

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
