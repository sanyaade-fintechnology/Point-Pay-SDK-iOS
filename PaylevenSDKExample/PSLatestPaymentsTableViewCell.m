//
//  PSLatestPaymentsTableViewCell.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLatestPaymentsTableViewCell.h"

@implementation PSLatestPaymentsTableViewCell

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end
