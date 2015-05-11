//
//  APPSAuthViewModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPSSignInModel.h"

#import "APPSAuthCommand.h"
#import "APPSMultipartCommand.h"

#import "APPSStrategyControllerDelegate.h"

@interface APPSAuthViewModel : NSObject<APPSCollectionViewModel>
@end

@interface APPSAuthViewModel ()

@property(strong, nonatomic) APPSRACBaseRequest *authCommand;
@property(strong, nonatomic) APPSSignInModel *model;

@end