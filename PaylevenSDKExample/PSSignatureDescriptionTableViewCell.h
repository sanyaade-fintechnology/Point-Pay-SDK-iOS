//
//  PSSignatureDescriptionTableViewCell.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/15/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;

@interface PSSignatureDescriptionTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cellAmountLabel;
@property (nonatomic, weak) IBOutlet UIButton *cellPayButton;
@property (nonatomic) UIColor *paylevenBlueBackgoundColor;
@property (nonatomic) UIColor *paylevenGrayBackgoundColor;

- (void)configureCellPayButtonForState:(BOOL)enabled;

@end
