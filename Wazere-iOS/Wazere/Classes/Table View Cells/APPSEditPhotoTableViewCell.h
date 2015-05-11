//
//  APPSSelectPhotoTableViewCell.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APPSEditPhotoTableViewCellDelegate<NSObject>
- (void)takeNewPhoto;
@end

@interface APPSEditPhotoTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *userImageView;
@property(weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property(weak, nonatomic) id<APPSEditPhotoTableViewCellDelegate> delegate;
@end
