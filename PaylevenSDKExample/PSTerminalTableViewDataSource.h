//
//  PSTerminalTableViewDataSource.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;
@class PSTerminalTableViewController;
@class PSManager;

@interface PSTerminalTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, weak) PSTerminalTableViewController *terminalTableViewController;
@property (nonatomic, weak) PSManager *manager;
@property (nonatomic) NSArray *sortedDevice;
@property (nonatomic) BOOL isBoardinDevice;

@end
