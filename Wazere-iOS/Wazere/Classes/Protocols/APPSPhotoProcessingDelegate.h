//
//  APPSPhotoProcessingDelegate.h
//  Wazere
//
//  Created by Gaidax on 12/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSPhotoProcessingDelegate_h
#define Wazere_APPSPhotoProcessingDelegate_h

@protocol APPSPhotoProcessingDelegate <NSObject>

@property(strong, nonatomic) UIImage *pickedImage;
@property(strong, nonatomic) UIImage *croppedImage;
@property(strong, nonatomic) UIImage *filteredImage;

@property(assign, nonatomic) BOOL showPicker;

- (void)didFinishProcessingImageWithSegue:(NSString *)segueIdentifier;

@end

#endif
