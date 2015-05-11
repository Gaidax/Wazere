//
//  APPSSharePhotoViewModel.m
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSSharePhotoViewModel.h"

@implementation APPSSharePhotoViewModel

@synthesize objects = _objects;
@synthesize command = _command;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

- (void)createModelsWithObjects:(NSArray *)objects {
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

@end
