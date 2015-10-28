//
//  PSLatestPaymentsTableViewDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import CoreData;
@import UIKit;
@class PSLatestPaymentsViewController;

@interface PSLatestPaymentsTableViewDelegate : NSObject<UITableViewDelegate>

@property (nonatomic, weak)PSLatestPaymentsViewController *latestPaymentsTableViewController;
@property (nonatomic) NSFetchedResultsController *fetchedResultController;

@end
