//
//  APPSCropViewController.m
//  Wazere
//
//  Created by Alexey Kalentyev on 12/8/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCropViewController.h"
#import <PECropView.h>
#import "APPSCameraConstants.h"

@interface APPSCropViewController () <UIScrollViewDelegate>
@property(weak, nonatomic) IBOutlet UIView *cropContainerView;
@property(strong, nonatomic) PECropView *cropView;
@end

@implementation APPSCropViewController

- (NSString *)screenName {
  return @"Camera crop screen";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];

  self.cropView = [[PECropView alloc] initWithFrame:self.cropContainerView.frame];
  self.cropView.image = self.pickedImage;
  [self.cropContainerView addSubview:self.cropView];

  [self.cropView setNeedsLayout];
  [self.cropView layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self resetCropRect];
  self.cropView.keepingCropAspectRatio = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  [self.processingDelegate setShowPicker:YES];
}

- (void)resetCropRect {
  [UIView setAnimationsEnabled:NO];
  CGFloat width = self.pickedImage.size.width;
  CGFloat height = self.pickedImage.size.height;
  CGFloat length = MIN(width, height);
  self.cropView.imageCropRect =
      CGRectMake((width - length) / 2, (height - length) / 2, length, length);

  [UIView setAnimationsEnabled:YES];
}

- (IBAction)resetButtonPressed:(id)sender {
  [self resetCropRect];
}

- (IBAction)saveButtonPressed:(id)sender {
  CGFloat newSize = 1080.0;
  UIImage *newImage;
  if (self.cropView.croppedImage.size.width > newSize) {
    UIGraphicsBeginImageContext(CGSizeMake(newSize, newSize));
    [self.cropView.croppedImage drawInRect:CGRectMake(0, 0, newSize, newSize)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  } else {
    newImage = self.cropView.croppedImage;
  }
  self.savedImage = newImage;
  self.processingDelegate.croppedImage = self.savedImage;
  self.processingDelegate.filteredImage = nil;
  [self.processingDelegate didFinishProcessingImageWithSegue:kCameraFilterSegue];
}

- (IBAction)retakeButtonPressed:(id)sender {
  [self.processingDelegate didFinishProcessingImageWithSegue:nil];
}

@end
