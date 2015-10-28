//
//  PSLatestPaymentsTableViewDataSource.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import CoreData;
@import UIKit;
@class PSLatestPaymentsViewController;
@class PSPayment;
@class PSManager;

@interface PSLatestPaymentsTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, weak)PSLatestPaymentsViewController *latestPaymentsTableViewController;
@property (nonatomic) NSFetchedResultsController *fetchedResultController;
@property (nonatomic) PSPayment *selectedPayment;
@property (nonatomic, weak) PSManager *manager;

@end
