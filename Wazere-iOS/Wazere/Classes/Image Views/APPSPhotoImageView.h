//
//  APPSBlurredImageView.h
//  Wazere
//
//  Created by Alexey Kalentyev on 11/25/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSPhotoImageView : UIImageView
@property(weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property(strong, nonatomic) UILabel *notAvailableLabel;
@property(assign, nonatomic) BOOL shouldBlur;
@property(copy, nonatomic) dispatch_block_t blurCompetionBlock;
- (UIImage *)blurredImageWithTagline;
- (UIImage *)createBlurredImage:(UIImage *)image;
- (void)createNotAviableLabel;
@end
