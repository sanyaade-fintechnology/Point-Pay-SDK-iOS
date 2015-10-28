//
//  PSHomeTableViewDelegate.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSHomeTableViewDelegate.h"
#import "PSHomeViewController.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
@import CoreData;

@implementation PSHomeTableViewDelegate

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
    case 0:
        [self.homeTableViewController performSegueWithIdentifier:PaymentViewSegue sender:self.homeTableViewController];
        break;
        case 1:{
            NSArray *sections = self.homeTableViewController.fetchedResultController.sections;
            id <NSFetchedResultsSectionInfo> sectionInfo = sections[0];
            if([sectionInfo numberOfObjects] > 0){
                [self.homeTableViewController performSegueWithIdentifier:LatestPaymentSegue sender:self.homeTableViewController];
            } else {
                [self.homeTableViewController performSegueWithIdentifier:LatestPaymentMissingSegue sender:self.homeTableViewController];
            }
        }
        break;
    case 2:
        if([self.manager.payleven.devices count] > 0){
            [self.homeTableViewController performSegueWithIdentifier:TerminalSegue sender:self.homeTableViewController];
        } else {
            [self.homeTableViewController performSegueWithIdentifier:TerminalMissingSegue sender:self.homeTableViewController];
        }
        break;
    case 3:
            [self.homeTableViewController performSegueWithIdentifier:LogoutProcessSegue sender:self.homeTableViewController];
        break;
        default:break;
    }
}

@end
