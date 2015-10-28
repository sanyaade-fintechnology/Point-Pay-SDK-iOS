//
//  PSLatestPaymentsTableViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//
@import UIKit;
@import CoreData;
@class PSLatestPaymentsTableViewDataSource;
@class PSLatestPaymentsTableViewDelegate;
@class PSCoreDataManager;
@class PSManager;
#import "PSManagerDelegate.h"

@interface PSLatestPaymentsViewController : UIViewController

@property (nonatomic, weak) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak) PSCoreDataManager *coreDataManager;
@property (nonatomic, strong) PSLatestPaymentsTableViewDataSource *dataSource;
@property (nonatomic, strong) PSLatestPaymentsTableViewDelegate *delegate;
@property (nonatomic, weak) PSManager *manager;
@property (nonatomic, weak) id <PSManagerDelegate> managerDelegate;
@property (weak, nonatomic) IBOutlet UIView *noRefundView;

@end
