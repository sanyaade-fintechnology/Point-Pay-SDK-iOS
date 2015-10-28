//
//  PSTerminalTableViewDelegate.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSTerminalTableViewDelegate.h"
#import "PSTerminalTableViewController.h"
#import "PSTerminalTableViewDataSource.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
#import <PaylevenSDK/PLVDevice.h>
#import <PaylevenSDK/PLVPayleven.h>

@implementation PSTerminalTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.bluetoothState == CBCentralManagerStatePoweredOn && self.manager.payleven.devices.count > 0){
        NSArray *sortedDevices = self.terminalTableViewController.dataSource.sortedDevice;
        PLVDevice *device = (PLVDevice *)sortedDevices[indexPath.row];
        self.terminalTableViewController.selectedDevice = device;
        [self.terminalTableViewController configureDevice:device];
    } else if (self.bluetoothState == CBCentralManagerStatePoweredOff) {
        [self.terminalTableViewController presentAlertViewWithErrorMessage:@"Please turn on your bluetooth" title:@"System error"];
        [self.terminalTableViewController.tableView reloadData];
    } else if (self.bluetoothState == CBCentralManagerStatePoweredOn && self.manager.payleven.devices.count == 0){
        [self.terminalTableViewController presentAlertViewWithErrorMessage:@"Please turn on your device" title:@"Device error"];
        [self.terminalTableViewController.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.1){
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    }
}

@end
