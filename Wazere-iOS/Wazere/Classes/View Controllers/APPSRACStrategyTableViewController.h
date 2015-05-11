//
//  ParseTableViewController.h
//  flocknest
//
//  Created by iOS Developer on 11/26/13.
//  Copyright (c) 2013 Rost K. All rights reserved.
//

#import "APPSRACCustomTableViewController.h"

@protocol APPSFunctionalLogicDelegate;

@protocol APPSRACTableViewDelegate;

@interface APPSRACStrategyTableViewController : APPSRACCustomTableViewController

@property(strong, NS_NONATOMIC_IOSONLY) id<UITableViewDelegate, APPSRACTableViewDelegate> delegate;
@property(strong, NS_NONATOMIC_IOSONLY) id<APPSFunctionalLogicDelegate> mainLogicDelegate;
@property(strong, NS_NONATOMIC_IOSONLY) UIRefreshControl *refreshControl;
@property(strong, NS_NONATOMIC_IOSONLY) UIView *firstResponder;

@property(assign, NS_NONATOMIC_IOSONLY) BOOL openedModally;

@property(assign, NS_NONATOMIC_IOSONLY) BOOL disableReload;

- (void)reloadTable;

@end
