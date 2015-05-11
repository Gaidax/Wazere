//
//  APPSTopBarContainerViewController.h
//  Wazere
//
//  Created by Petr Yanenko on 9/17/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "APPSViewController.h"
#import "APPSSharePhotoContainerDelegate.h"

@interface APPSTopBarContainerViewController : APPSViewController

@property(strong, nonatomic) id<APPSTopBarContainerViewControllerDelegate> delegate;
@property(weak, nonatomic) IBOutlet UIView *contentView;

@property(weak, nonatomic) IBOutlet UIView *topBar;

@property(weak, nonatomic) IBOutlet UIButton *leftBarButton;
@property(weak, nonatomic) IBOutlet UIButton *centerBarButton;
@property(weak, nonatomic) IBOutlet UIButton *rightBarButton;

@end
