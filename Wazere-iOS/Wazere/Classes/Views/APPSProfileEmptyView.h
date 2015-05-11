//
//  APPSProfileEmptyView.h
//  Wazere
//
//  Created by Gaidax on 12/12/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPSProfileEmptyView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (assign, nonatomic) BOOL topImageViewHidden;

@end
