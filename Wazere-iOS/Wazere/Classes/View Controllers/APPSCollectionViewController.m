//
//  FNCollectionViewController.m
//  flocknest
//
//  Created by iOS Developer on 12/19/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSCollectionViewController.h"

@interface APPSCollectionViewController ()

@end

@implementation APPSCollectionViewController

- (void)dealloc {
  _collectionView.dataSource = nil;
  _collectionView.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
