//
//  APPSUserFeedsModel.m
//  Wazere
//
//  Created by Gaidax on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSUserFeedsModel.h"

@implementation APPSUserFeedsModel

- (BOOL)shouldShowImages {
  return [self.feedType integerValue] == APPSNewsFeedTypeLike && self.feeds.count > 1;
}

- (void)setFeeds:(NSArray *)feeds {
  NSMutableArray *newFeeds = [[NSMutableArray alloc] init];
  for (id feed in feeds) {
    if ([feed isKindOfClass:[APPSNewsFeedModel class]]) {
      [newFeeds addObject:feed];
    } else {
      [newFeeds
          addObject:[[APPSNewsFeedModel alloc] initWithDictionary:(NSDictionary *)feed error:nil]];
    }
  }
  _feeds = [newFeeds copy];
}

- (BOOL)hasOneRecepient {
  APPSSomeUser *recepient = ((APPSNewsFeedModel *) (self.feeds)[0]).recipient;
  for (APPSNewsFeedModel *newsFeed in self.feeds) {
    if (![recepient.userId isEqualToNumber:newsFeed.recipient.userId]) {
      return NO;
    }
  }
  return YES;
}

- (APPSNewsFeedModel *)firstNewsFeedModel {
  return [self.feeds firstObject];
}

@end
