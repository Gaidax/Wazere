//
//  CommandDataSource.h
//  flocknest
//
//  Created by austinate on 20.05.14.
//  Copyright (c) 2014 Applikey Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPSObjectsViewModelProtocol;

@protocol APPSStrategyDataSource<NSObject, NSCoding>

@optional
@property(strong, nonatomic) id<APPSObjectsViewModelProtocol> viewModel;

@end
