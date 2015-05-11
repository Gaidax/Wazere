//
//  APPSObjectsViewModelProtocol.h
//  Wazere
//
//  Created by iOS Developer on 9/10/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

@protocol APPSCommand;

@protocol APPSObjectsViewModelProtocol<NSObject, NSCoding>

@property(strong, nonatomic) NSArray *objects;
@property(strong, nonatomic) id<APPSCommand> command;

- (void)createModelsWithObjects:(NSArray *)objects;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
