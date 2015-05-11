//
//  APPSHomeDelegate.h
//  Wazere
//
//  Created by iOS Developer on 10/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSMapPhotosDelegate.h"

@interface APPSHomeDelegate : APPSMapPhotosDelegate<UICollectionViewDelegateFlowLayout>
@property(strong, NS_NONATOMIC_IOSONLY) NSString *filter;
- (void)changeLayoutButtonPressed:(UIBarButtonItem *)sender;
@end
