//
//  APPSSignInViewModel.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/5/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSAuthViewModel.h"

#import "APPSSignInModel.h"

@interface APPSSignInViewModel : APPSAuthViewModel<APPSCollectionViewModel>

@property(strong, nonatomic) NSMutableArray *errorStrings;
@property(strong, nonatomic) RACCommand *signInCommand;
@property(strong, nonatomic) RACCommand *forgotPasswordCommand;

@end
