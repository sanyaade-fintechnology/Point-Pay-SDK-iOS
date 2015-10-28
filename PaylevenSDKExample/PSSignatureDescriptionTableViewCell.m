//
//  PSSignatureDescriptionTableViewCell.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/15/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSSignatureDescriptionTableViewCell.h"

@implementation PSSignatureDescriptionTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellPayButtonForState:(BOOL)enabled {
    if(enabled){
        self.cellPayButton.backgroundColor = self.paylevenBlueBackgoundColor;
    } else {
        self.cellPayButton.backgroundColor = self.paylevenGrayBackgoundColor;
    }
}

@end
