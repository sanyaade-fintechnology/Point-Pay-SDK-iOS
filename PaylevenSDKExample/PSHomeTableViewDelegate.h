//
//  PSHomeTableViewDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;
@class PSHomeViewController;
@class PSManager;

@interface PSHomeTableViewDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, weak) IBOutlet PSHomeViewController *homeTableViewController;
@property (nonatomic, weak) PSManager *manager;

@end
