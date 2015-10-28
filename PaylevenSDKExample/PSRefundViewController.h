//
//  PSRefundViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager;
@class PSCoreDataManager;
@class PSPayment;
@protocol PSManagerDelegate;

@interface PSRefundViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *externalIdTextField;
@property (nonatomic, weak) PSManager *manager;
@property (nonatomic, weak) id <PSManagerDelegate> managerDelegate;
@property (nonatomic, weak) PSCoreDataManager *coreDataManager;
@property (nonatomic) PSPayment *payment;

@end
