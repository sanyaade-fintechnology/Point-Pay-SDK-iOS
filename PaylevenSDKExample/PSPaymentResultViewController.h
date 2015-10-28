//
//  PSPaymentResultViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PLVPaymentTask;
@class PSManager;

@interface PSPaymentResultViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *paymentResultImageView;
@property (nonatomic, weak) IBOutlet UILabel *paymentResultLabel;
@property (nonatomic, weak) IBOutlet UIButton *showReceiptButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (nonatomic) PLVPaymentTask *paymentTask;
@property (nonatomic, weak) PSManager *manager;

@end
