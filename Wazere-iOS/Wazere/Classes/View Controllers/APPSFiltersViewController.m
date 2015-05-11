//
//  APPSFiltersViewController.m
//  Wazere
//
//  Created by iOS Developer on 9/15/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSFiltersViewController.h"
#import "APPSCameraConstants.h"

#import "ASAmatorkaFilter.h"

#import "ASContrastFilter.h"

#import "ASGrayscaleFilter.h"

#import "ASLighteningFilter.h"
#import "ASMissEticateFilter.h"
#import "ASNormalFilter.h"
#import "ASPosterizeFilter.h"
#import "ASSepiaFilter.h"
#import "ASToneShiftMinusFilter.h"
#import "ASToneShiftPlusFilter.h"

@interface APPSFiltersViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
                                         UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) IBOutlet UIView *topView;
@property(weak, nonatomic) IBOutlet UICollectionView *filtersView;

@property(weak, nonatomic) IBOutlet UIButton *closeButton;
@property(weak, nonatomic) IBOutlet UIButton *contrastButton;
@property(weak, nonatomic) IBOutlet UIButton *nextButton;

@property(strong, nonatomic) NSArray *filters;
@property(strong, nonatomic) NSMutableDictionary *filterPreviews;

@end

// RAC
@interface APPSFiltersViewController ()

@property(weak, nonatomic) IBOutlet UIImageView *mainImage;

@end

@implementation APPSFiltersViewController

static NSString *const previewImageName = @"photo_filter";

- (NSString *)screenName {
  return @"Camera filters";
}

- (void)dealloc {
  _filtersView.delegate = nil;
  _filtersView.dataSource = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.filters = [self filters];

  @weakify(self);
  [[RACObserve(self, mainImage.image) ignore:nil] subscribeNext:^(UIImage *mainImage) {
      @strongify(self);
      self.savedImage = mainImage;
  }];
  APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:self.view];
  [spinner startAnimating];
  UIImage *originImage = self.pickedImage;
  dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *compressedImage = [self compressOriginImage:originImage];

      NSMutableDictionary *previews = [self createPreviews];

      dispatch_async(dispatch_get_main_queue(), ^{
          self.filterPreviews = previews;
          [self.filtersView reloadData];
          self.pickedImage = compressedImage;
          self.mainImage.image = self.savedImage ? self.savedImage : self.pickedImage;
          [spinner stopAnimating];
      });
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self.processingDelegate setShowPicker:YES];
}

- (NSArray *)filters {
  return @[
    [[ASNormalFilter alloc] init],
    [[ASAmatorkaFilter alloc] init],
    [[ASGrayscaleFilter alloc] init],
    //      [[ASHardLightFilter alloc] init],
    [[ASLighteningFilter alloc] init],
    [[ASMissEticateFilter alloc] init],
    [[ASPosterizeFilter alloc] init],
    [[ASSepiaFilter alloc] init],
    [[ASToneShiftMinusFilter alloc] init],
    [[ASToneShiftPlusFilter alloc] init],
    //      [[ASVignetteFilter alloc] init],
    //      [[ASWaterColorFilter alloc] init]
  ];
}

- (UIImage *)compressOriginImage:(UIImage *)originImage {
  NSData *compressedData = UIImageJPEGRepresentation(originImage, 1.0);
  UIImage *compressedImage = [UIImage imageWithData:compressedData];
  if (compressedImage == nil) {
    NSLog(@"%@", [NSError errorWithDomain:@"APPSFiltersViewController"
                                     code:0
                                 userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Image is nil"
                                 }]);
  }
  return compressedImage;
}

- (NSMutableDictionary *)createPreviews {
  NSMutableDictionary *previews = [NSMutableDictionary dictionaryWithCapacity:self.filters.count];
  //  for (ASImageFilter *filter in self.filters) {
  //    UIImage *filteredImage =
  //        [filter filteredImage:[UIImage imageNamed:previewImageName]];
  //    if (filteredImage) {
  //      previews[[filter name]] = filteredImage;
  //    } else {
  //      NSLog(@"%@", [NSError errorWithDomain:@"APPSFiltersViewController"
  //                                       code:1
  //                                   userInfo:@{
  //                                     NSLocalizedFailureReasonErrorKey :
  //                                         @"Filtered image not created"
  //                                   }]);
  //    }
  //  }
  return previews;
}

- (IBAction)tapsCloseButton:(UIButton *)sender {
    [self.processingDelegate didFinishProcessingImageWithSegue:kCameraCropSegue];
}

- (IBAction)tapsContrastButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (sender.selected) {
    [self filterImage:self.pickedImage
           withFilter:[[ASContrastFilter alloc] init]
            imageView:self.mainImage];
  } else {
    self.mainImage.image = self.pickedImage;
  }
}

- (IBAction)tapsNextButton:(UIButton *)sender {
    self.processingDelegate.filteredImage = self.savedImage;
    [self.processingDelegate didFinishProcessingImageWithSegue:kSharePhotoSegue];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:kFiltersCell forIndexPath:indexPath];
  UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kFilterImageViewTag];
  imageView.clipsToBounds = YES;
  imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0;
  ASImageFilter *filter = (ASImageFilter *)self.filters[indexPath.row];
  UIImage *preview = self.filterPreviews[[filter name]];
  if (preview) {
    imageView.image = preview;
  } else {
    [self filterPreviewImage:[UIImage imageNamed:previewImageName]
                  withFilter:filter
                   indexPath:indexPath];
  }
  UILabel *label = (UILabel *)[cell.contentView viewWithTag:kFilterLabelTag];
  label.text = filter.name;
  label.font = FONT_CHAMPAGNE_LIMOUSINES_BOLD(12.5);
  label.textColor = [UIColor whiteColor];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  ASImageFilter *filter = (ASImageFilter *)self.filters[indexPath.row];
  UIImage *originImage = self.pickedImage;
  [self filterImage:originImage withFilter:filter imageView:self.mainImage];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(95, 95);
}

- (void)filterImage:(UIImage *)originImage
         withFilter:(ASImageFilter *)filter
          imageView:(UIImageView *)imageView {
  APPSSpinnerView *spinner = [[APPSSpinnerView alloc] initWithSuperview:self.view];
  [spinner startAnimating];
  dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *filteredImage = [filter filteredImage:originImage];
      dispatch_async(dispatch_get_main_queue(), ^{
          imageView.image = filteredImage;
          [spinner stopAnimating];
      });
  });
}

- (void)filterPreviewImage:(UIImage *)originImage
                withFilter:(ASImageFilter *)filter
                 indexPath:(NSIndexPath *)indexPath {
  dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *filteredImage = [filter filteredImage:originImage];
      if (filteredImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.filterPreviews[[filter name]] = filteredImage;
            [self.filtersView reloadItemsAtIndexPaths:@[ indexPath ]];
        });
      } else {
        NSLog(@"%@",
              [NSError errorWithDomain:@"APPSFiltersViewController"
                                  code:2
                              userInfo:@{
                                NSLocalizedFailureReasonErrorKey : @"Filtered image not created"
                              }]);
      }
  });
}

@end
