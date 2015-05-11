//
//  CommandDataSource.h
//  flocknest
//
//  Created by austinate on 20.05.14.
//  Copyright (c) 2014 Applikey Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPSCollectionViewModel<NSObject, NSCoding>

@property(strong, nonatomic) NSArray *objects;

- (id)objectInObectsAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol APPSStrategyControllerDelegate<NSObject, NSCoding>

@property(strong, nonatomic) id<APPSCollectionViewModel> viewModel;

@optional
- (BOOL)viewController:(UIViewController *)viewController
    shouldPerformSegueWithIdentifier:(NSString *)identifier
                              sender:(id)sender;
- (void)removeViewController:(UIViewController *)viewController;

@end
