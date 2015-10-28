//
//  PSLatestPaymentsTableViewCell.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;

@interface PSLatestPaymentsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *paymentDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *paymentAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *paymentIdentifierLabel;

@end
