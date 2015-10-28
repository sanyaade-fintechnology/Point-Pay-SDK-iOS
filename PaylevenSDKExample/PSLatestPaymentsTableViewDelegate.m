//
//  PSLatestPaymentsTableViewDelegate.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLatestPaymentsTableViewDelegate.h"
#import "PSLatestPaymentsViewController.h"
#import "PSLatestPaymentsTableViewDataSource.h"
#import "PSPayment.h"
#import "PSIdentifiers.h"

@implementation PSLatestPaymentsTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPayment *payment = [self.fetchedResultController objectAtIndexPath:indexPath];
    self.latestPaymentsTableViewController.dataSource.selectedPayment = payment;
    [self.latestPaymentsTableViewController performSegueWithIdentifier:RefundViewSegue sender:self.latestPaymentsTableViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57.00;
}

@end
