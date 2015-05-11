//
//  APPSCameraConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 9/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCameraConfigurator.h"
#import "APPSCameraViewController.h"

@interface APPSCameraViewController ()

@property(strong, nonatomic) IBOutlet UIView *overlayView;

@property(weak, nonatomic) IBOutlet UIView *topView;
@property(weak, nonatomic) IBOutlet UIView *bottomView;

@property(weak, nonatomic) IBOutlet UIButton *makePhotoButton;
@property(weak, nonatomic) IBOutlet UIButton *flashButton;
@property(weak, nonatomic) IBOutlet UIButton *changeCameraButton;
@property(weak, nonatomic) IBOutlet UIButton *gridButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;

@property(weak, nonatomic) IBOutlet UIView *gridView;
@property(weak, nonatomic) IBOutlet UIView *leftGridView;
@property(weak, nonatomic) IBOutlet UIView *rightGridView;
@property(weak, nonatomic) IBOutlet UIView *topGridView;
@property(weak, nonatomic) IBOutlet UIView *bottomGridView;

@end

@implementation APPSCameraConfigurator

- (void)configureViewController:(APPSCameraViewController *)controller {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [self configureOverlayViewForController:controller];
    controller.pickerController = [self createImagePickerForController:controller];
  } else {
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:NSLocalizedString(@"Camera unavailable", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                         otherButtonTitles:nil];
    [alert show];
  }
}

- (UIImagePickerController *)createImagePickerForController:(APPSCameraViewController *)controller {
  //  NSArray *mediaTypes = [UIImagePickerController
  //      availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  picker.mediaTypes = @[ (NSString *)kUTTypeImage ];
  //  controller.overlayView.frame = picker.view.frame;
  //  picker.cameraOverlayView = controller.overlayView;
  //  picker.showsCameraControls = NO;
  picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
  picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
  picker.allowsEditing = NO;
  picker.delegate = controller;
  return picker;
}

- (void)configureOverlayViewForController:(APPSCameraViewController *)controller {
  //  controller.overlayView =
  //      (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"CameraOverlayView"
  //                                               owner:controller
  //                                             options:nil] firstObject];
  controller.leftGridView.layer.shadowOffset = controller.rightGridView.layer.shadowOffset =
      controller.topGridView.layer.shadowOffset = controller.bottomGridView.layer.shadowOffset =
          SHADOW_OFFSET;

  controller.leftGridView.layer.shadowOpacity = controller.rightGridView.layer.shadowOpacity =
      controller.topGridView.layer.shadowOpacity = controller.bottomGridView.layer.shadowOpacity =
          shadowOpacity;

  controller.leftGridView.layer.shadowRadius = controller.rightGridView.layer.shadowRadius =
      controller.topGridView.layer.shadowRadius = controller.bottomGridView.layer.shadowRadius =
          shadowRadius;

  [controller.gridView removeConstraints:[controller.gridView constraints]];

  controller.rightGridView.translatesAutoresizingMaskIntoConstraints =
      controller.leftGridView.translatesAutoresizingMaskIntoConstraints =
          controller.topGridView.translatesAutoresizingMaskIntoConstraints =
              controller.bottomGridView.translatesAutoresizingMaskIntoConstraints = YES;

  controller.leftGridView.autoresizingMask = controller.rightGridView.autoresizingMask =
      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |
      UIViewAutoresizingFlexibleRightMargin;

  controller.topGridView.autoresizingMask = controller.bottomGridView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |
      UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |
      UIViewAutoresizingFlexibleBottomMargin;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

@end
