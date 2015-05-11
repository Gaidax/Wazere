//
//  APPSPinPhotosController.m
//  Wazere
//
//  Created by iOS Developer on 11/27/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSPinPhotosController.h"
#import "APPSPinPhotosConfigurator.h"
#import "APPSPinPhotosDelegate.h"
#import "APPSProfileViewController.h"
#import "APPSPinModel.h"

@interface APPSPinPhotosController ()

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIView *gridViewContainer;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UILabel *titleView;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet UIButton *closeButton;

@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet NSLayoutConstraint *topConstraint;
@property(weak, NS_NONATOMIC_IOSONLY) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation APPSPinPhotosController

static NSString *const kPinPhotosChildSegue = @"PinPhotosChildSegue";

- (void)viewDidLoad {
  [super viewDidLoad];
  [self performSegueWithIdentifier:kPinPhotosChildSegue sender:self];
  self.titleView.text =
      [NSString stringWithFormat:@"%lu photos", (unsigned long)[self.pin.photos count]];
  self.titleView.textColor = UIColorFromRGB(163, 35, 62, 1.0);
  self.view.backgroundColor = UIColorFromRGB(0, 0, 0, 0.3);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self backAction:self.closeButton];
}

- (IBAction)backAction:(UIButton *)sender {
  [self willMoveToParentViewController:nil];
  [self.view removeFromSuperview];
  [self removeFromParentViewController];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPinPhotosChildSegue]) {
    APPSProfileViewController *pinPhotoController =
        (APPSProfileViewController *)[segue destinationViewController];
    APPSPinPhotosConfigurator *configurator = [[APPSPinPhotosConfigurator alloc] init];
    pinPhotoController.configurator = configurator;
    APPSPinPhotosDelegate *delegate =
        [[APPSPinPhotosDelegate alloc] initWithViewController:pinPhotoController
                                                          pin:self.pin
                                                       photos:self.photos];
    pinPhotoController.delegate = delegate;
    pinPhotoController.dataSource = delegate;
  }
}

@end
