//
//  PSHomeViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager;
@class PSHomeTableViewDelegate;
@class PSHomeTableViewDataSource;
#import "PSLogoutDelegate.h"
#import "PSCoreDataManagerDelegate.h"

@interface PSHomeViewController : UIViewController< PSLogoutDelegate,
                                                    PSCoreDataManagerDelegate
                                                    >

@property (weak, nonatomic) IBOutlet PSHomeTableViewDelegate *tableViewDelegate;
@property (weak, nonatomic) IBOutlet PSHomeTableViewDataSource *tableViewDataSource;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) PSManager *manager;
@property (nonatomic)NSFetchedResultsController *fetchedResultController;

@end
