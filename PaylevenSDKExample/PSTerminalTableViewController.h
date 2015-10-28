//
//  PSTerminalTableViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSTerminalTableViewDataSource;
@class PSTerminalTableViewDelegate;
@class PLVDevice;
@class PSManager;
@protocol PSManagerDelegate;

@interface PSTerminalTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet PSTerminalTableViewDelegate *delegate;
@property (nonatomic, weak) IBOutlet PSTerminalTableViewDataSource *dataSource;
@property (nonatomic, weak) PSManager *manager;
@property (nonatomic) PLVDevice *selectedDevice;
@property (nonatomic, weak) id <PSManagerDelegate> managerDelegate;

- (void)presentAlertViewWithErrorMessage:(NSString *)aMessage title:(NSString *)title;
- (void)configureDevice:(PLVDevice *)device;

@end
