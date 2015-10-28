//
//  PSTerminalTableViewCell.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;

@interface PSTerminalTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cellTerminalDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *cellTerminalImageView;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end
