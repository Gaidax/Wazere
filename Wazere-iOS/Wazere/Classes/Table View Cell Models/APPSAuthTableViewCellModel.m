//
//  APPSAuthTableViewCellModel.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/4/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAuthTableViewCellModel.h"

@implementation APPSAuthTableViewCellModel

- (instancetype)init {
  self = [super init];
  if (self) {
    [self validity];
  }
  return self;
}

- (void)validity {
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [self init];
  if (self) {
    self.textFiledBackgroundColor = [aDecoder decodeObjectForKey:@"color"];
    self.leftImage = [aDecoder decodeObjectForKey:@"image"];
    self.textFieldText = [aDecoder decodeObjectForKey:@"text"];
    self.textFieldPlaceholder = [aDecoder decodeObjectForKey:@"placeholder"];
    self.returnKeyType = [aDecoder decodeIntegerForKey:@"returnKey"];
    self.secureTextEntry = [aDecoder decodeBoolForKey:@"secureEntry"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.textFiledBackgroundColor forKey:@"color"];
  [aCoder encodeObject:self.leftImage forKey:@"image"];
  [aCoder encodeObject:self.textFieldText forKey:@"text"];
  [aCoder encodeObject:self.textFieldPlaceholder forKey:@"placeholder"];
  [aCoder encodeInteger:self.returnKeyType forKey:@"returnKey"];
  [aCoder encodeBool:self.secureTextEntry forKey:@"secureEntry"];
}

@end
