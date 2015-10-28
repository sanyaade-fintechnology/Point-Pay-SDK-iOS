//
//  PSTerminalTableViewDataSource.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSTerminalTableViewDataSource.h"
#import "PSTerminalTableViewController.h"
#import "PSTerminalTableViewCell.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
#import <PaylevenSDK/PLVDevice.h>
#import <PaylevenSDK/PLVPayleven.h>

@implementation PSTerminalTableViewDataSource

- (void)setBoardinDevice:(BOOL)boardinDevice {
    [self setBoardinDevice:boardinDevice];
}

- (NSArray *)sortedDevice {
    if(_sortedDevice) {
        return _sortedDevice;
    }
    
    return [self.manager.payleven.devices sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PLVDevice *device1 = (PLVDevice *)obj1;
        PLVDevice *device2 = (PLVDevice *)obj2;
        return [device1.name compare:device2.name];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.sortedDevice){
        return self.sortedDevice.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(!self.manager.selectedDevice || self.isBoardinDevice){
        return @"Choose a device";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView terminalTableViewCellTableViewCellForRowAtIndexPath:indexPath];
}

- (PSTerminalTableViewCell *)tableView:(UITableView *)tableView terminalTableViewCellTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTerminalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TerminalTableViewCell forIndexPath:indexPath];
    PLVDevice *device = self.sortedDevice[indexPath.row];
    if (device == self.manager.selectedDevice) {
        if (self.isBoardinDevice) {
            [cell.activityIndicatorView startAnimating];
            cell.accessoryView = cell.activityIndicatorView;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.cellTerminalImageView.image = [UIImage imageNamed:PaylevenCNP];
        } else {
            [cell.activityIndicatorView stopAnimating];
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.cellTerminalDescriptionLabel.text = [self deviceDisplayName:device.name];
            cell.cellTerminalImageView.image = [UIImage imageNamed:PaylevenCNPSelected];
        }
    }else {
        [cell.activityIndicatorView stopAnimating];
        cell.cellTerminalDescriptionLabel.text = [self deviceDisplayName:device.name];
        cell.cellTerminalImageView.image = [UIImage imageNamed:PaylevenCNP];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)deviceDisplayName:(NSString *)name {
    return [name stringByReplacingOccurrencesOfString:@"Shuttle" withString:@"Payleven"];
}

@end
