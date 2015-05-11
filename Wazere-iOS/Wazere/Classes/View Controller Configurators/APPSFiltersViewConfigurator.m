//
//  APPSFiltersViewConfigurator.m
//  Wazere
//
//  Created by iOS Developer on 9/16/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFiltersViewConfigurator.h"
#import "APPSFiltersViewController.h"
#import "APPSCameraConstants.h"

@interface APPSFiltersViewController ()

@property(weak, nonatomic) IBOutlet UIView *topView;
@property(weak, nonatomic) IBOutlet UICollectionView *filtersView;

@property(weak, nonatomic) IBOutlet UIButton *closeButton;
@property(weak, nonatomic) IBOutlet UIButton *contrastButton;
@property(weak, nonatomic) IBOutlet UIButton *nextButton;

@property(strong, nonatomic) NSArray *filters;

@end

// RAC
@interface APPSFiltersViewController ()

@property(weak, nonatomic) IBOutlet UIImageView *mainImage;

@end

@implementation APPSFiltersViewConfigurator

- (void)configureViewController:(APPSFiltersViewController *)controller {
  //    controller.mainImage.image = controller.pickedImage;
  controller.nextButton.titleLabel.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(barBattonItemFontSize);
    controller.view.backgroundColor = [UIColor blackColor];
  UINib *filtersCellNib = [UINib nibWithNibName:@"FiltersCollectionViewCell" bundle:nil];
  [controller.filtersView registerNib:filtersCellNib forCellWithReuseIdentifier:kFiltersCell];
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
