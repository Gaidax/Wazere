//
//  APPSGridCell.h
//  Wazere
//
//  Created by iOS Developer on 11/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPSPhotoImageView;

@interface APPSGridCell : UICollectionViewCell

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet APPSPhotoImageView *gridImage;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIImageView *userImage;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UILabel *usernameLabel;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *viewsButton;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *likesButton;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *commentsButton;

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIView *userView;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIView *photoInformationView;

@end
