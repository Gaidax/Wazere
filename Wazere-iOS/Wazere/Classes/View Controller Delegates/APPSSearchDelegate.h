//
//  SearchDelegate.h
//  Presentation project
//
//  Created by Petr Yanenko on 8/29/13.
//  Copyright (c) 2013 Petr Yanenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPSMapViewController;

@interface APPSSearchDelegate : NSObject<UISearchBarDelegate, UISearchDisplayDelegate,
                                         UITableViewDataSource, UITableViewDelegate>

- (id)initWithMapController:(APPSMapViewController *)controller;

@end
