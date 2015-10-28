//
//  PSRefundResultViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Obi on 9/23/15.
//  Copyright © 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager, PLVRefundResult;

@interface PSRefundResultViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *paymentResultImageView;
@property (nonatomic, weak) IBOutlet UILabel *paymentResultLabel;
@property (nonatomic, weak) IBOutlet UIButton *showReceiptButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, weak) PSManager *manager;
@property (nonatomic, weak) PLVRefundResult *refundResult;
@property (nonatomic) NSString *refundMessage;

@end
