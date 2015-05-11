//
//  APPSFacebookSignInViewControllerDelegate.m
//  Wazere
//
//  Created by Petr Yanenko on 1/21/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

#import "APPSFacebookSignUpViewControllerDelegate.h"
#import "APPSAuthTableViewCell.h"

@implementation APPSFacebookSignUpViewControllerDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  APPSAuthTableViewCell *cell = (APPSAuthTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
  if ([cell.model isMemberOfClass:[APPSAuthTableViewCellModel class]]) {
    cell.textField.enabled = NO;
    cell.textField.layer.borderWidth = 0.0;
  }
  return cell;
}

@end
