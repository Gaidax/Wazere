//
//  APPSCameraViewController.m
//  Wazere
//
//  Created by Petr Yanenko on 9/14/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSCameraViewController.h"
#import "APPSCameraConstants.h"
#import "APPSCameraConfigurator.h"
#import "APPSTabBarViewController.h"

#import <mach/mach.h>

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

@implementation APPSCameraViewController
@synthesize pickedImage = _pickedImage, croppedImage = _croppedImage,
            filteredImage = _filteredImage, showPicker = _showPicker;

- (void)dealloc {
  _pickerController.delegate = nil;
}

- (NSString *)screenName {
  return @"Camera";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.showPicker = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.showPicker) {
    [self presentCameraViewController];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setShowPicker:(BOOL)showPicker {
  _showPicker = showPicker;
  if (_showPicker) {
    self.pickedImage = nil;
    self.croppedImage = nil;
    self.filteredImage = nil;
  }
}

BOOL check_low_memory() {
  mach_port_t host_port;
  mach_msg_type_number_t host_size;
  vm_size_t pagesize;

  host_port = mach_host_self();
  host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
  host_page_size(host_port, &pagesize);

  vm_statistics_data_t vm_stat;

  if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
    NSLog(@"Failed to fetch vm statistics");
  }

  /* Stats in bytes */
  //  unsigned long mem_used =
  //      (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
  unsigned long mem_free = vm_stat.free_count * pagesize;
  //  unsigned long mem_total = mem_used + mem_free;
  NSUInteger megabyte = 1024 * 1024, lowMemoryCondition = 20;
  BOOL lowMemory = NO;
  if (mem_free < lowMemoryCondition * megabyte) {
    [[APPSTabBarViewController rootViewController] cleanSystemMemory];
    lowMemory = YES;
  }
  return lowMemory;
}

- (void)disposeViewControllerNotification:(NSNotification *)notification {
  if (self.pickerController && self.presentedViewController == self.pickerController) {
    [self dismissViewControllerAnimated:NO completion:NULL];
    self.pickerController.delegate = nil;
    self.pickerController = nil;
  }
}

- (void)calculateYOffset:(CGFloat *)outYOffset scale:(CGFloat *)outScale {
  CGSize screenSize = self.gridView.frame.size;
  CGFloat cameraAspectRatio = 3.0 / 4.0;
  CGFloat cameraWidth = screenSize.width;
  CGFloat cameraHeight = cameraWidth / cameraAspectRatio;

  CGFloat scale = screenSize.height / cameraHeight;
  if (scale < 1.0) {
    scale = 1.0;
  }
  CGFloat scaledCameraHeight = scale * cameraHeight;
  CGFloat yOffset =
      CGRectGetHeight(self.topView.frame) - (scaledCameraHeight - screenSize.height) / 2.0;
  if (outScale) {
    *outScale = scale;
  }
  if (outYOffset) {
    *outYOffset = yOffset;
  }
}

- (void)changeFlashIcon {
  if (self.pickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
    [self.flashButton setImage:[UIImage imageNamed:@"flash_auto"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"flash_auto_click"]
                      forState:UIControlStateHighlighted];
  } else if (self.pickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn) {
    [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"flash_clicked"]
                      forState:UIControlStateHighlighted];
  } else {
    [self.flashButton setImage:[UIImage imageNamed:@"flash_without"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"flash_without_click"]
                      forState:UIControlStateHighlighted];
  }
}

- (IBAction)tapsFlashButton:(UIButton *)sender {
  if ([UIImagePickerController
          isFlashAvailableForCameraDevice:self.pickerController.cameraDevice]) {
    if (self.pickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
      self.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    } else if (self.pickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
      self.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    } else {
      self.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
    [self changeFlashIcon];
  }
}

- (IBAction)tapsChangeCameraButton:(UIButton *)sender {
  UIImagePickerControllerCameraDevice device = self.pickerController.cameraDevice;
  UIImagePickerControllerCameraDevice newDevice;
  if (device == UIImagePickerControllerCameraDeviceRear) {
    newDevice = UIImagePickerControllerCameraDeviceFront;
  } else {
    newDevice = UIImagePickerControllerCameraDeviceRear;
  }
  if ([UIImagePickerController isCameraDeviceAvailable:newDevice]) {
    NSArray *captureTypes =
        [UIImagePickerController availableCaptureModesForCameraDevice:newDevice];
    if (self.pickerController.cameraCaptureMode == UIImagePickerControllerCameraCaptureModeVideo &&
        ![captureTypes containsObject:@(UIImagePickerControllerCameraCaptureModeVideo)]) {
      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:nil
                                     message:NSLocalizedString(@"Video mode unavailable", nil)
                                    delegate:nil
                           cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                           otherButtonTitles:nil];
      [alert show];
    } else {
      self.pickerController.cameraDevice = newDevice;
      self.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
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

- (IBAction)tapsGridButton:(UIButton *)sender {
  self.gridView.hidden = !self.gridView.hidden;
}

- (IBAction)tapsCloseButton:(UIButton *)sender {
  self.tabBarController.selectedViewController = self.tabBarController.viewControllers[homeIndex];
  self.showPicker = YES;
  [self dismissViewControllerAnimated:NO completion:NULL];
}

- (IBAction)tapsMakePhotoMovieButton:(UIButton *)sender {
  if (self.pickerController.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto) {
    [self.pickerController takePicture];
  } else {
    if (![self.pickerController startVideoCapture]) {
      [self.pickerController stopVideoCapture];
    }
  }
}

- (CGRect)cropRectForImage:(UIImage *)image {
  if (image.imageOrientation == UIImageOrientationLeft ||
      image.imageOrientation == UIImageOrientationLeftMirrored ||
      image.imageOrientation == UIImageOrientationRight ||
      image.imageOrientation == UIImageOrientationRightMirrored) {
    CGFloat offset = (image.size.height - image.size.width) / 2.0;
    return CGRectMake(offset, 0, image.size.width, image.size.width);
  }
  CGFloat offset = (image.size.width - image.size.height) / 2.0;
  return CGRectMake(offset, 0, image.size.height, image.size.height);
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = info[UIImagePickerControllerOriginalImage];
  //  UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
  //  CGFloat scale = image.scale;
  //  UIImageOrientation orientation = image.imageOrientation;
  //
  //  CGRect cropRect = [self cropRectForImage:image];
  //  CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],
  //  cropRect);
  //  UIImage *cropedImage =
  //      [UIImage imageWithCGImage:imageRef scale:scale
  //      orientation:orientation];
  //  CGImageRelease(imageRef);
  self.pickedImage = image;
  [self showViewcontrollerWithSegueIdentifier:kCameraCropSegue];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self tapsCloseButton:self.backButton];
}

#pragma mark - Cropping Delegate

- (void)didFinishProcessingImageWithSegue:(NSString *)segueIdentifier {
  [self showViewcontrollerWithSegueIdentifier:segueIdentifier];
}

- (void)showViewcontrollerWithSegueIdentifier:(NSString *)segueIdentifier {
  self.showPicker = segueIdentifier == nil;
  [self dismissViewControllerAnimated:NO
                           completion:^{
                               if (!self.showPicker) {
                                 self.pickerController.delegate = nil;
                                 self.pickerController = nil;
                                 [self performSegueWithIdentifier:segueIdentifier sender:self];
                               }
                           }];
}

#pragma mark - Controllers Presentation

- (void)presentCameraViewController {
  BOOL isLowMemory = check_low_memory();
  CGFloat delay = isLowMemory ? 0.5 : DISPATCH_TIME_NOW;
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  @weakify(self);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
      @strongify(self);
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
      if (self.pickerController == nil) {
        [self.configurator configureViewController:self];
      }
      if (self.pickerController) {
        //          CGFloat yOffset, scale;
        //          [self calculateYOffset:&yOffset scale:&scale];
        //          CGAffineTransform translate = CGAffineTransformMakeTranslation(0, yOffset);
        //          CGAffineTransform scaledScreen = CGAffineTransformMakeScale(scale, scale);
        //          CGAffineTransform fullTranform = CGAffineTransformConcat(scaledScreen,
        //          translate);

        //          self.pickerController.cameraViewTransform = fullTranform;
        [self presentViewController:self.pickerController animated:NO completion:NULL];
      }
  });
}

@end
